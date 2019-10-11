class PersonnummerException implements Exception {
  String cause = 'Invalid swedish social security number';
  PersonnummerException([this.cause]);
}