import 'package:test/test.dart';
import 'package:personnummer/personnummer.dart';

var invalidNumbers = [
  null,
  [],
  true,
  false,
  0,
  '19112233-4455',
  '20112233-4455',
  '9999999999',
  '199999999999',
  '199909193776',
  'Just a string',
];

void main() {
  Personnummer.dateTimeNow = new DateTime(2019, 7, 13);

  test('should validate personnummer with control digit', () {
    expect(true, Personnummer.valid('198507099805'));
    expect(true, Personnummer.valid('198507099813'));
    expect(true, Personnummer.valid('196411139808'));
  });

  test('should not validate personnummer without control digit', () {
    expect(false, Personnummer.valid('19850709980'));
    expect(false, Personnummer.valid('19850709981'));
    expect(false, Personnummer.valid('19641113980'));
  });

  test('should not validate wrong personnummer or wrong types', () {
    invalidNumbers.forEach((n) => expect(false, Personnummer.valid(n)));
  });

  test('should validate co-ordination numbers', () {
    expect(true, Personnummer.valid('198507699802'));
    expect(true, Personnummer.valid('850769-9802'));
    expect(true, Personnummer.valid('198507699810'));
    expect(true, Personnummer.valid('850769-9810'));
  });

  test('should not validate wrong co-ordination numbers', () {
    expect(false, Personnummer.valid('198567099805'));
  });

  test('should format input values correct', () {
    expect('850709-9805', Personnummer.format('19850709-9805'));
    expect('850709-9813', Personnummer.format('198507099813'));

    var opts = new PersonnummerOptions(longFormat: true);
    expect('198507099805', Personnummer.format('19850709-9805', opts));
    expect('198507099813', Personnummer.format('198507099813', opts));
  });

  test('should format input values and replace separator with the right one', () {
    expect('850709-9805', Personnummer.format('19850709+9805'));
    expect('121212+1212', Personnummer.format('19121212-1212'));
  });

  test('should test format with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.format(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });

  test('should test age', () {
    expect(34, Personnummer.getAge('198507099805'));
    expect(34, Personnummer.getAge('198507099813'));
    expect(106, Personnummer.getAge('19121212+1212'));
  });

  test('should test age with co-ordination numbers', () {
    expect(34, Personnummer.getAge('198507699810'));
    expect(34, Personnummer.getAge('198507699802'));
  });

  test('should test get age with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.getAge(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });

  test('should test sex', () {
    var opts = new PersonnummerOptions(includeCoordinationNumber: false);
    expect(true, Personnummer.isMale(198507099813, opts));
    expect(false, Personnummer.isFemale(198507099813, opts));
    expect(true, Personnummer.isFemale('850709-9805', opts));
    expect(false, Personnummer.isMale('850709-9805', opts));
  });

  test('should test sex with co-ordination numbers', () {
    expect(true, Personnummer.isMale('198507099813'));
    expect(false, Personnummer.isFemale('198507099813'));
    expect(true, Personnummer.isFemale('198507699802'));
    expect(false, Personnummer.isMale('198507699802'));
  });

  test('should test sex with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.isMale(n);
      } catch (e) {
        expect(true, e != null);
      }

      try {
        Personnummer.isFemale(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });
}