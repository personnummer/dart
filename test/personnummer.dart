import 'package:test/test.dart';
import 'package:personnummer/personnummer.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future<String> fetchUrlBodyAsString(String url) async {
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  return response.transform(utf8.decoder).join();
}

var availableListFormats = [
  'long_format',
  'short_format',
  'separated_format',
  'separated_long',
];

void main() async {
  final url =
      'https://raw.githubusercontent.com/personnummer/meta/master/testdata/list.json';
  String body = await fetchUrlBodyAsString(url);
  dynamic list = jsonDecode(body);
  runTests(list);
}

void runTests(dynamic list) {
  test('should validate personnummer with control digit', () {
    for (var item in list) {
      for (var format in availableListFormats) {
        expect(item["valid"], Personnummer.valid(item[format]));
      }
    }
  });

  test('should format personnummer', () {
    for (var item in list) {
      if (!item['valid']) {
        return;
      }

      for (var format in availableListFormats) {
        if (format != 'short_format') {
          expect(item["separated_format"],
              Personnummer.parse(item[format]).format());
          expect(item["long_format"],
              Personnummer.parse(item[format]).format(true));
        }
      }
    }
  });

  test('should throw personnummer error', () {
    for (var item in list) {
      if (item["valid"]) {
        return;
      }

      for (var format in availableListFormats) {
        try {
          Personnummer.parse(item[format]);
          expect(false, true);
        } catch (e) {
          expect(true, true);
        }
      }
    }
  });

  test('should test personnummer sex', () {
    for (var item in list) {
      if (!item["valid"]) {
        return;
      }

      for (var format in availableListFormats) {
        expect(item["isMale"], Personnummer.parse(item[format]).isMale());
        expect(item["isFemale"], Personnummer.parse(item[format]).isFemale());
      }
    }
  });

  test('should test personnummer age', () {
    for (var item in list) {
      if (!item['valid']) {
        return;
      }

      for (var format in availableListFormats) {
        if (format != 'short_format') {
          var pin = item["separated_long"];
          var year = int.parse(pin.substring(0, 4));
          var month = int.parse(pin.substring(4, 6));
          var day = int.parse(pin.substring(6, 8));

          if (item["type"] == 'con') {
            day = day - 60;
          }

          var date = DateTime(year, month, day);
          Personnummer.dateTimeNow = date;
          expect(0, Personnummer.parse(item[format]).getAge());
        }
      }
    }
  });
}
