class PersonnummerException implements Exception {
  String cause = 'Invalid swedish social security number';
  PersonnummerException([this.cause]);
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
  Personnummer(String ssn, [dynamic options]) {
    _parse(ssn);
  }

  /// Luhn/mod10 algorithm. Used to calculate a checksum from the passed value
  /// The checksum is returned and tested against the control number
  /// in the social security number to make sure that it is a valid number.
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

  /// Parse Swedish social security numbers and set properties.
  void _parse(String ssn) {
    var reg = RegExp(
        r'^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$');
    var match;

    try {
      match = reg.firstMatch(ssn);

      if (match == null) {
        throw PersonnummerException();
      }
    } catch (e) {
      throw PersonnummerException();
    }

    var _century = match[1];
    var _year = match[2];
    var _month = match[3];
    var _day = match[4];
    var _sep = match[5];
    var _nm = match[6];
    var _check = match[7];

    if (_check.isEmpty) {
      throw PersonnummerException();
    }

    if (_century == null || _century.isEmpty) {
      var baseYear;
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
  }

  /// Test year, month and day as date and see if it's the same.
  /// Returns `true` if it's the same.
  bool _testDate(int year, int month, int day) {
    var date = DateTime(year, month, day);
    return !(date.year != year || date.month != month || date.day != day);
  }

  /// Validates Swedish social security numbers.
  /// Returns `true` if the input value is a valid Swedish social security number.
  bool _valid() {
    try {
      var valid = _luhn(year + month + day + num) == int.parse(check);

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

  /// Format Swedish social security numbers to official format.
  String format([bool longFormat = false]) {
    if (longFormat) {
      return century + year + month + day + num + check;
    }

    return year + month + day + sep + num + check;
  }

  // Get age from a Swedish social security number.
  int getAge() {
    var ageDay = int.parse(day);
    if (isCoordinationNumber()) {
      ageDay -= 60;
    }

    var pnrDate = DateTime(int.parse(century + year), int.parse(month), ageDay);

    var dt;
    if (dateTimeNow == null) {
      dt = DateTime.now();
    } else {
      dt = dateTimeNow;
    }

    return (dt.difference(pnrDate).inMilliseconds / 3.15576e+10).floor();
  }

  /// Check if a Swedish social security number is a coordination number or not.
  /// Returns `true` if it's a coordination number.
  bool isCoordinationNumber() {
    return _testDate(int.parse(year), int.parse(month), int.parse(day) - 60);
  }

  /// Check if a Swedish social security number is for a female.
  /// Returns `true` if it's a female.
  bool isFemale() {
    return !isMale();
  }

  /// Check if a Swedish social security number is for a male.
  /// Returns `true` if it's a male.
  bool isMale() {
    var sexDigit = num.substring(num.length - 1);

    return int.parse(sexDigit) % 2 == 1;
  }

  // Custom DateTime that should be used
  // to modifiy DateTime.now.
  static DateTime dateTimeNow;

  /// Parse Swedish social security numbers.
  /// Returns `Personnummer` class.
  static Personnummer parse(String ssn, [dynamic options]) {
    return Personnummer(ssn, options);
  }

  /// Validates Swedish social security numbers.
  /// Returns `true` if the input value is a valid Swedish social security number
  static bool valid(String ssn, [dynamic options]) {
    try {
      parse(ssn, options);
      return true;
    } catch (e) {
      return false;
    }
  }
}
