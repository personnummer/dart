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
    expect(true, Personnummer.valid('200002296127'));
    expect(true, Personnummer.valid('200002296127'));
    expect(true, Personnummer.valid('200002283422'));
    expect(true, Personnummer.valid('101010-1010'));
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
    expect(true, Personnummer.valid(7010632391));
    expect(true, Personnummer.valid(6408833231));
  });

  test('should not validate wrong co-ordination numbers', () {
    expect(false, Personnummer.valid('900161-0017'));
    expect(false, Personnummer.valid('640893-3231'));
    expect(false, Personnummer.valid('6102802424'));
  });

  test('should not accept co-ordination numbers', () {
    expect(false, Personnummer.valid('701063-2391', false));
    expect(false, Personnummer.valid('640883-3231', false));
    expect(false, Personnummer.valid(7010632391, false));
    expect(false, Personnummer.valid(6408833231, false));
  });

  test('should format input values correct', () {
    expect('640327-3813', Personnummer.format(6403273813));
    expect('510818-9167', Personnummer.format('510818-9167'));
    expect('900101-0017', Personnummer.format('19900101-0017'));
    expect('130401+2931', Personnummer.format('19130401+2931'));
    expect('640823-3234', Personnummer.format('196408233234'));
    expect('000101-0107', Personnummer.format('0001010107'));
    expect('000101-0107', Personnummer.format('000101-0107'));
    expect('130401+2931', Personnummer.format('191304012931'));
    expect('196403273813', Personnummer.format(6403273813, true));
    expect('195108189167', Personnummer.format('510818-9167', true));
    expect('199001010017', Personnummer.format('19900101-0017', true));
    expect('191304012931', Personnummer.format('19130401+2931', true));
    expect('196408233234', Personnummer.format('196408233234', true));
    expect('200001010107', Personnummer.format('0001010107', true));
    expect('200001010107', Personnummer.format('000101-0107', true));
    expect('190001010107', Personnummer.format('000101+0107', true));
  });

  test('should test age', () {
    expect(55, Personnummer.getAge(6403273813));
    expect(67, Personnummer.getAge('510818-9167'));
    expect(29, Personnummer.getAge('19900101-0017'));
    expect(106, Personnummer.getAge('19130401+2931'));
  });

  test('should test age with co-ordination numbers', () {
    expect(48, Personnummer.getAge('701063-2391'));
    expect(54, Personnummer.getAge('640883-3231'));
  });

  test('should return empty age with co-ordination numbers', () {
    expect(0, Personnummer.getAge('701063-2391', false));
    expect(0, Personnummer.getAge('640883-3231', false));
  });
}