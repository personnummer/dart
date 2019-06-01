import 'package:test/test.dart';
import 'package:personnummer/personnummer.dart';

void main() {
  test('should validate personnummer with control digit', () {
    expect(true, Personnummer.valid(6403273813));
    expect(true, Personnummer.valid('510818-9167'));
    expect(true, Personnummer.valid('19900101-0017'));
    expect(true, Personnummer.valid('19130401+2931'));
    expect(true, Personnummer.valid('196408233234'));
    expect(true, Personnummer.valid('000101-0107'));
    expect(true, Personnummer.valid('0001010107'));
  });

  test('should not validate personnummer without control digit', () {
    expect(false, Personnummer.valid(640327381));
    expect(false, Personnummer.valid('510818-916'));
    expect(false, Personnummer.valid('19900101-001'));
    expect(false, Personnummer.valid('100101+001'));
  });

  test('should not validate wrong personnummer or wrong types', () {
    expect(false, Personnummer.valid(null));
    expect(false, Personnummer.valid([]));
    expect(false, Personnummer.valid({}));
    expect(false, Personnummer.valid(false));
    expect(false, Personnummer.valid(true));
    expect(false, Personnummer.valid(1122334455));
    expect(false, Personnummer.valid('112233-4455'));
    expect(false, Personnummer.valid('19112233-4455'));
    expect(false, Personnummer.valid('9999999999'));
    expect(false, Personnummer.valid('199999999999'));
    expect(false, Personnummer.valid('9913131315'));
    expect(false, Personnummer.valid('9911311232'));
    expect(false, Personnummer.valid('9902291237'));
    expect(false, Personnummer.valid('19990919_3766'));
    expect(false, Personnummer.valid('990919_3766'));
    expect(false, Personnummer.valid('199909193776'));
    expect(false, Personnummer.valid('Just a string'));
    expect(false, Personnummer.valid('990919+3776'));
    expect(false, Personnummer.valid('990919-3776'));
    expect(false, Personnummer.valid('9909193776'));
  });

  test('should validate co-ordination numbers', () {
    expect(true, Personnummer.valid('701063-2391'));
    expect(true, Personnummer.valid('640883-3231'));
  });

  test('should not validate wrong co-ordination numbers', () {
    expect(false, Personnummer.valid('900161-0017'));
    expect(false, Personnummer.valid('640893-3231'));
  });
}