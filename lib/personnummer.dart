import 'dart:collection';
import './personnumer_exception.dart';

class Personnummer {
  /// Validates Swedish social security numbers. Both string and numbers are allowed.
  /// Returns a `true` if the input value is a valid Swedish social security number.
  static bool valid(dynamic input, [bool includeCoordinationNumber = true]) {
    HashMap parts = getParts(input);

    if (parts.isEmpty) {
      return false;
    }

    bool valid =
        luhn(parts['year'] + parts['month'] + parts['day'] + parts['nm']) ==
            int.parse(parts['check']);

    if (valid &&
        testDate(int.parse(parts['year']), int.parse(parts['month']),
            int.parse(parts['day']))) {
      return valid;
    }

    if (!includeCoordinationNumber) {
      return false;
    }

    return valid &&
        testDate(int.parse(parts['year']), int.parse(parts['month']),
            int.parse(parts['day']) - 60);
  }

  /// Parse Swedish social security numbers and get the parts.
  /// Returns a HashMap with the parts.
  static HashMap getParts(dynamic input) {
    HashMap map = new HashMap();
    input = input.toString();

    RegExp reg = new RegExp(
        r'^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$');
    Match match = reg.firstMatch(input);

    if (match == null) {
      return map;
    }

    String century = match[1];
    String year = match[2];
    String month = match[3];
    String day = match[4];
    String sep = match[5];
    String nm = match[6];
    String check = match[7];

    if (check.isEmpty) {
      return map;
    }

    if (century == null || century.isEmpty) {
      int baseYear;
      if (sep == '+') {
        baseYear = (new DateTime(DateTime.now().year - 100)).year;
      } else {
        baseYear = DateTime.now().year;
      }

      century = (baseYear - (baseYear - int.parse(year)) % 100)
          .toString()
          .substring(0, 2);
    }

    if (sep == null || sep.isEmpty) {
      sep = '-';
    }

    // Set the right separator to match the full year.
    // >= 100 should use + and < 100 should use -
    var yearDiff = DateTime.now().year - int.parse(century + year);
    if (sep == '-' && yearDiff >= 100) {
      sep = '+';
    } else if (sep == '+' && yearDiff < 100) {
      sep = '-';
    }

    map['century'] = century;
    map['year'] = year;
    map['month'] = month;
    map['day'] = day;
    map['sep'] = sep;
    map['nm'] = nm;
    map['check'] = check;

    return map;
  }

  /// Get the age from a personnummer.
  static int getAge(dynamic input, [bool includeCoordinationNumber = true]) {
    if (!valid(input, includeCoordinationNumber)) {
      throw new PersonnummerException();
    }

    HashMap parts = getParts(input);
    if (parts.isEmpty) {
      throw new PersonnummerException();
    }

    int day = int.parse(parts['day']);
    if (day >= 61 && day <= 91) {
      day -= 60;
    }

    DateTime u = new DateTime(int.parse(parts['century'] + parts['year']),
        int.parse(parts['month']), day);
    DateTime dt = dateTimeNow == null ? DateTime.now() : dateTimeNow;

    return (dt.difference(u).inMilliseconds / 3.15576e+10).floor();
  }

  /// Format Swedish social security numbers to official format.
  ///
  /// When [longFormat] is `true` `YYYYMMDDXXXX` will be returned and
  /// when `false` `YYMMDD-XXXX` will be returned.
  ///
  /// Tax office says both are official.
  static String format(dynamic input, [bool longFormat = false]) {
    if (!valid(input)) {
      throw new PersonnummerException();
    }

    HashMap parts = getParts(input);

    if (parts.isEmpty) {
      throw new PersonnummerException();
    }

    if (longFormat) {
      return parts['century'] +
          parts['year'] +
          parts['month'] +
          parts['day'] +
          parts['nm'] +
          parts['check'];
    }

    return parts['year'] +
        parts['month'] +
        parts['day'] +
        parts['sep'] +
        parts['nm'] +
        parts['check'];
  }

  // Check if a Swedish social security number is for a female.
  /// Returns `true` if it's a female.
  static bool isFemale(dynamic input, [bool includeCoordinationNumber = true]) {
    return !isMale(input, includeCoordinationNumber);
  }

  // Check if a Swedish social security number is for a male.
  /// Returns `true` if it's a male.
  static bool isMale(dynamic input, [bool includeCoordinationNumber = true]) {
    if (!valid(input, includeCoordinationNumber)) {
      throw new PersonnummerException();
    }

    HashMap parts = getParts(input);

    if (parts.isEmpty) {
      throw new PersonnummerException();
    }

    var sexDigit = parts['nm'].substring(parts['nm'].length - 1);

    return int.parse(sexDigit) % 2 == 1;
  }

  /// Luhn/mod10 algorithm. Used to calculate a checksum from the passed value
  /// The checksum is returned and tested against the control number
  /// in the social security number to make sure that it is a valid number.
  static int luhn(String str) {
    int v = 0;
    int sum = 0;

    for (int i = 0, l = str.length; i < l; i++) {
      v = int.parse(str[i]);
      v *= 2 - (i % 2);
      if (v > 9) {
        v -= 9;
      }
      sum += v;
    }

    return (sum / 10).ceil() * 10 - sum;
  }

  /// Test year, month and day as date and see if it's the same.
  /// Returns `true` if it's the same.
  static bool testDate(int year, int month, int day) {
    DateTime date = new DateTime(year, month, day);
    return !(date.year != year || date.month != month || date.day != day);
  }

  // Custom DateTime that should be used
  // to modifiy DateTime.now.
  static DateTime dateTimeNow;
}
