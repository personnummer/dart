class Personnummer {
  // Validate Swedish social security numbers. String or number is allowed.
  static bool valid(dynamic input) {
    input = input.toString();

    RegExp reg = new RegExp(
        r'^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$');
    RegExpMatch match = reg.firstMatch(input);

    if (match == null) {
      return false;
    }

    String century = match[1];
    String year = match[2];
    String month = match[3];
    String day = match[4];
    String sep = match[5];
    String nm = match[6];
    String check = match[7];

    if (year.length == 4) {
      year = year.substring(2);
    }

    if (check.length == 0) {
      return false;
    }

    bool valid = luhn(year + month + day + nm) == int.parse(check);

    if (valid && testDate(int.parse(year), int.parse(month), int.parse(day))) {
      return valid;
    }

    return valid &&
        testDate(int.parse(year), int.parse(month), int.parse(day) - 60);
  }

  // The Luhn algorithm to validate number.
  static int luhn(String str) {
    int v = 0;
    int sum = 0;

    str += '';

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

  // Test year, month and day as date and see if it's the same.
  static bool testDate(int year, int month, int day) {
    DateTime date = new DateTime(year, month, day);
    return !(date.year != year || date.month != month || date.day != day);
  }
}