class PersonnummerException implements Exception {
  String cause = 'Invalid swedish social security number';
  PersonnummerException([this.cause]);
}

class Personnummer {
  /**
   * Personnummer age.
   */
  String age = '';

  /**
   * Personnummer century.
   */
  String century = '';

  /**
   * Personnummer full year.
   */
  String fullYear = '';

  /**
   * Personnummer year.
   */
  String year = '';

  /**
   * Personnummer month.
   */
  String month = '';

  /**
   * Personnummer day.
   */
  String day = '';

  /**
   * Personnummer seperator.
   */
  String sep = '';

  /**
   * Personnummer first three of the last four numbers.
   */
  String num = '';

  /**
   * The last number of the personnummer.
   */
  String check = '';

  /// Personnummer constructor.
  Personnummer(String ssn, [dynamic options = null]) {
    this._parse(ssn);
  }

  /// Luhn/mod10 algorithm. Used to calculate a checksum from the passed value
  /// The checksum is returned and tested against the control number
  /// in the social security number to make sure that it is a valid number.
  int _luhn(String str) {
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

  /// Parse Swedish social security numbers and set properties.
  _parse(String ssn) {
    RegExp reg = new RegExp(
        r'^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$');
    Match match = null;

    try {
      match = reg.firstMatch(ssn);

      if (match == null) {
        return;
      }
    } catch (e) {
      return;
    }

    String century = match[1];
    String year = match[2];
    String month = match[3];
    String day = match[4];
    String sep = match[5];
    String nm = match[6];
    String check = match[7];

    if (check.isEmpty) {
      return;
    }

    if (century == null || century.isEmpty) {
      int baseYear;
      if (sep == '+') {
        baseYear = (new DateTime(DateTime.now().year - 100)).year;
      } else {
        sep = '-';
        baseYear = DateTime.now().year;
      }

      century = (baseYear - (baseYear - int.parse(year)) % 100)
          .toString()
          .substring(0, 2);
    } else {
      if (DateTime.now().year - int.parse(century + year) < 100) {
        sep = '-';
      } else {
        sep = '+';
      }
    }

    this.century = century;
    this.fullYear = century + year;
    this.year = year;
    this.month = month;
    this.day = day;
    this.sep = sep;
    this.num = nm;
    this.check = check;

    int ageDay = int.parse(day);
    if (ageDay >= 61 && ageDay <= 91) {
      ageDay -= 60;
    }

    DateTime u =
        new DateTime(int.parse(century + year), int.parse(month), ageDay);
    DateTime dt = dateTimeNow == null ? DateTime.now() : dateTimeNow;

    this.age =
        (dt.difference(u).inMilliseconds / 3.15576e+10).floor().toString();
  }

  /// Test year, month and day as date and see if it's the same.
  /// Returns `true` if it's the same.
  bool _testDate(int year, int month, int day) {
    DateTime date = new DateTime(year, month, day);
    return !(date.year != year || date.month != month || date.day != day);
  }

  /// Format Swedish social security numbers to official format.
  String format([bool longFormat = false]) {
    if (!this.isValid()) {
      throw new PersonnummerException();
    }

    if (longFormat) {
      return this.century +
          this.year +
          this.month +
          this.day +
          this.num +
          this.check;
    }

    return this.year + this.month + this.day + this.sep + this.num + this.check;
  }

  /// Check if a Swedish social security number is a coordination number or not.
  /// Returns `true` if it's a coordination number.
  bool isCoordinationNumber() {
    var day = int.parse(this.day);
    return day >= 61 && day < 91;
  }

  /// Check if a Swedish social security number is for a female.
  /// Returns `true` if it's a female.
  bool isFemale() {
    return !isMale();
  }

  /// Check if a Swedish social security number is for a male.
  /// Returns `true` if it's a male.
  bool isMale() {
    if (!this.isValid()) {
      throw new PersonnummerException();
    }

    var sexDigit = this.num.substring(this.num.length - 1);

    return int.parse(sexDigit) % 2 == 1;
  }

  /// Validates Swedish social security numbers.
  /// Returns `true` if the input value is a valid Swedish social security number.
  bool isValid() {
    try {
      bool valid = this._luhn(this.year + this.month + this.day + this.num) ==
          int.parse(this.check);

      var year = int.parse(this.year);
      var month = int.parse(this.month);
      var day = int.parse(this.day);

      if (valid && this._testDate(year, month, day)) {
        return valid;
      }

      return valid && this._testDate(year, month, day - 60);
    } catch (e) {
      return false;
    }
  }

  // Custom DateTime that should be used
  // to modifiy DateTime.now.
  static DateTime dateTimeNow;

  /// Parse Swedish social security numbers.
  /// Returns `Personnummer` class.
  static Personnummer parse(String ssn, [dynamic options = null]) {
    return new Personnummer(ssn, options);
  }

  /// Validates Swedish social security numbers.
  /// Returns `true` if the input value is a valid Swedish social security number
  static bool valid(String ssn, [dynamic options = null]) {
    return parse(ssn, options).isValid();
  }
}
