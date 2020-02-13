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
    expect(true, Personnummer.valid('8507099805'));
    expect(true, Personnummer.valid('198507099805'));
    expect(true, Personnummer.valid('198507099813'));
    expect(true, Personnummer.valid('850709-9813'));
    expect(true, Personnummer.valid('196411139808'));
  });

  test('should not validate personnummer without control digit', () {
    expect(false, Personnummer.valid('19850709980'));
    expect(false, Personnummer.valid('19850709981'));
    expect(false, Personnummer.valid('19641113980'));
  });

  test('should not validate wrong personnummer or wrong types', () {
    invalidNumbers.forEach((n) => expect(false, Personnummer.valid(n.toString())));
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

  test('should parse personnummer and set properties', () {
    var pnr = Personnummer.parse('198507699802');
    expect('34', pnr.age);
    expect('19', pnr.century);
    expect('1985', pnr.fullYear);
    expect('85', pnr.year);
    expect('07', pnr.month);
    expect('69', pnr.day);
    expect('-', pnr.sep);
    expect('980', pnr.num);
    expect('2', pnr.check);
  });

  test('should throw errors for bad inputs when parsing', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.parse(n.toString());
        expect(false, true);
      } catch (e) {
        expect(true, true);
      }
    });
  });

  test('should format input values correct', () {
    expect('850709-9805', Personnummer.parse('19850709-9805').format());
    expect('850709-9813', Personnummer.parse('198507099813').format());

    expect('198507099805', Personnummer.parse('19850709-9805').format(true));
    expect('198507099813', Personnummer.parse('198507099813').format(true));
  });

  test('should format input values and replace separator with the right one', () {
    expect('850709-9805', Personnummer.parse('19850709+9805').format());
    expect('121212+1212', Personnummer.parse('19121212-1212').format());
  });

  test('should test age', () {
    expect('34', Personnummer.parse('198507099805').age);
    expect('34', Personnummer.parse('198507099813').age);
    expect('54', Personnummer.parse('196411139808').age);
    expect('106', Personnummer.parse('19121212+1212').age);
  });

  test('should test age with co-ordination numbers', () {
    expect('34', Personnummer.parse('198507699810').age);
    expect('34', Personnummer.parse('198507699802').age);
  });

  test('should test sex', () {
    expect(true, Personnummer.parse('198507099813').isMale());
    expect(false, Personnummer.parse('198507099813').isFemale());
    expect(true, Personnummer.parse('850709-9805').isFemale());
    expect(false, Personnummer.parse('850709-9805').isMale());
  });

  test('should test sex with co-ordination numbers', () {
    expect(true, Personnummer.parse('198507099813').isMale());
    expect(false, Personnummer.parse('198507099813').isFemale());
    expect(true, Personnummer.parse('198507699802').isFemale());
    expect(false, Personnummer.parse('198507699802').isMale());
  });
}