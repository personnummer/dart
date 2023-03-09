class PersonnummerException implements Exception {
  String cause;
  PersonnummerException(
      [this.cause = 'Invalid swedish personal identity number']);
}

class PersonnummerOptions {
  // Allow coordination number.
  bool allowCoordinationNumber = true;

  /// Allow interim number.
  bool allowInterimNumber = false;

  PersonnummerOptions(
      {bool? allowCoordinationNumber, bool? allowInterimNumber}) {
    allowCoordinationNumber = allowCoordinationNumber;
    allowInterimNumber = allowInterimNumber;
  }
}

class Personnummer {
  /// Personnummer age.
  String age = '';

  /// Personnummer century.
  String century = '';

  /// Personnummer full year.
  String fullYear = '';

  /// Personnummer year.
  String year = '';

  /// Personnummer month.
  String month = '';

  /// Personnummer day.
  String day = '';

  /// Personnummer seperator.
  String sep = '';

  /// Personnummer first three of the last four numbers.
  String num = '';

  /// The last number of the personnummer.
  String check = '';

  /// Personnummer constructor.
  Personnummer(String pin,
      {bool allowCoordinationNumber = true, bool allowInterimNumber = false}) {
    _parse(pin,
        allowCoordinationNumber: allowCoordinationNumber,
        allowInterimNumber: allowInterimNumber);
  }

  /// Luhn/mod10 algorithm. Used to calculate a checksum from the passed value
  /// The checksum is returned and tested against the control number
  /// in the personal identity number to make sure that it is a valid number.
  int _luhn(String str) {
    var v = 0;
    var sum = 0;

    for (var i = 0, l = str.length; i < l; i++) {
      v = int.parse(str[i]);
      v *= 2 - (i % 2);
      if (v > 9) {
        v -= 9;
      }
      sum += v;
    }

    return (sum / 10).ceil() * 10 - sum;
  }

  /// Parse Swedish personal identity numbers and set properties.
  void _parse(String pin,
      {bool allowCoordinationNumber = true, bool allowInterimNumber = false}) {
    if (pin.length < 10 || pin.length > 13) {
      throw PersonnummerException(
          "Input value too ${pin.length > 13 ? "long" : "short"}");
    }

    var reg = RegExp(
        r'^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([+-]?)((?!000)\d{3}|[TRSUWXJKLMN]\d{2})(\d)$');
    RegExpMatch? match;

    try {
      match = reg.firstMatch(pin);
    } catch (e) {
      throw PersonnummerException();
    }

    if (match == null) {
      throw PersonnummerException();
    }

    var _century = match[1];
    var _year = match[2]!;
    var _month = match[3]!;
    var _day = match[4]!;
    var _sep = match[5]!;
    var _nm = match[6]!;
    var _check = match[7];

    if (_check == null || _check.isEmpty) {
      throw PersonnummerException();
    }

    if (_century == null || _century.isEmpty) {
      int baseYear;
      if (_sep == '+') {
        baseYear = (DateTime(DateTime.now().year - 100)).year;
      } else {
        _sep = '-';
        baseYear = DateTime.now().year;
      }

      _century = (baseYear - (baseYear - int.parse(_year)) % 100)
          .toString()
          .substring(0, 2);
    } else {
      if (DateTime.now().year - int.parse(_century + _year) < 100) {
        _sep = '-';
      } else {
        _sep = '+';
      }
    }

    century = _century;
    fullYear = _century + _year;
    year = _year;
    month = _month;
    day = _day;
    sep = _sep;
    num = _nm;
    check = _check;

    if (!_valid()) {
      throw PersonnummerException();
    }

    // throw error if coordination numbers is not allowed.
    if (!allowCoordinationNumber && isCoordinationNumber()) {
      throw PersonnummerException();
    }

    // throw error if interim numbers is not allowed.
    if (!allowInterimNumber && isInterimNumber()) {
      throw PersonnummerException();
    }
  }

  /// Test year, month and day as date and see if it's the same.
  /// Returns `true` if it's the same.
  bool _testDate(int year, int month, int day) {
    var date = DateTime(year, month, day);
    return !(date.year != year || date.month != month || date.day != day);
  }

  /// Validates Swedish personal identity numbers.
  /// Returns `true` if the input value is a valid Swedish personal identity number.
  bool _valid() {
    try {
      var valid = _luhn(year +
              month +
              day +
              num.replaceFirst(RegExp(r'[TRSUWXJKLMN]'), '1')) ==
          int.parse(check);

      var localYear = int.parse(year);
      var localMonth = int.parse(month);
      var localDay = int.parse(day);

      if (valid && _testDate(localYear, localMonth, localDay)) {
        return valid;
      }

      return valid && _testDate(localYear, localMonth, localDay - 60);
    } catch (e) {
      return false;
    }
  }

  /// Format Swedish personal identity numbers to official format.
  String format([bool longFormat = false]) {
    if (longFormat) {
      return century + year + month + day + num + check;
    }

    return year + month + day + sep + num + check;
  }

  /// Get date from a Swedish personal identity number.
  DateTime getDate() {
    var ageDay = int.parse(day);
    if (isCoordinationNumber()) {
      ageDay -= 60;
    }

    return DateTime(int.parse(century + year), int.parse(month), ageDay);
  }

  /// Get age from a Swedish personal identity number.
  int getAge() {
    DateTime dt;
    if (dateTimeNow == null) {
      dt = DateTime.now();
    } else {
      dt = dateTimeNow!;
    }

    return (dt.difference(getDate()).inMilliseconds / 3.15576e+10).floor();
  }

  /// Check if a Swedish personal identity number is a coordination number or not.
  /// Returns `true` if it's a coordination number.
  bool isCoordinationNumber() {
    return _testDate(int.parse(year), int.parse(month), int.parse(day) - 60);
  }

  /// Check if a Swedish personal identity number is a interim number or not.
  /// Returns `true` if it's a interim number.
  bool isInterimNumber() {
    return RegExp(r'[TRSUWXJKLMN]').hasMatch(num[0]);
  }

  /// Check if a Swedish personal identity number is for a female.
  /// Returns `true` if it's a female.
  bool isFemale() {
    return !isMale();
  }

  /// Check if a Swedish personal identity number is for a male.
  /// Returns `true` if it's a male.
  bool isMale() {
    var sexDigit = num.substring(num.length - 1);

    return int.parse(sexDigit) % 2 == 1;
  }

  // Custom DateTime that should be used
  // to modifiy DateTime.now.
  static DateTime? dateTimeNow;

  /// Parse Swedish personal identity numbers.
  /// Returns `Personnummer` class.
  static Personnummer parse(String pin,
      {bool allowCoordinationNumber = true, bool allowInterimNumber = false}) {
    return Personnummer(pin,
        allowCoordinationNumber: allowCoordinationNumber,
        allowInterimNumber: allowInterimNumber);
  }

  /// Validates Swedish personal identity numbers.
  /// Returns `true` if the input value is a valid Swedish personal identity number
  static bool valid(String pin,
      {bool allowCoordinationNumber = true, bool allowInterimNumber = false}) {
    try {
      Personnummer(pin,
          allowCoordinationNumber: allowCoordinationNumber,
          allowInterimNumber: allowInterimNumber);
      return true;
    } catch (_) {
      return false;
    }
  }
}
