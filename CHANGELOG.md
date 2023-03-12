## 3.1.0

Personnummer v3.1 API Spec implemented.

- Added options for allowing coordination numbers (true by default) and interim number (false by default).
- Added support for interim numbers
- Added `isInterimNumber` function
- Added `getDate` function

## 3.0.5

- Migrate to null-safety, see [#8](https://github.com/personnummer/dart/pull/8)

## 3.0.4

- Fixed whitespace separator issue, see [personnummer/meta#41](https://github.com/personnummer/meta/issues/41)

## 3.0.3

- Fixed an issue where last four digits in personnumers with invalid data could be parsed.

## 3.0.2

- Improve package health score by using [pana tool](https://github.com/dart-lang/pana) to analyze the code.

## 3.0.1

- Improve `isCoordinationNumber` to test the date
- Make use of `isCoordinationNumber` inside `getAge` to determine the real day.

## 3.0.0

> The one that breaks everything

- Brand new version that follow the new [specification](https://github.com/personnummer/meta#package-specification-v3).

## 2.1.0

- Added `isMale`
- Added `isFemale`
- Improved `format` to replace the separator if it's not matching the full year.

## 2.0.0

- Added `getAge`
- Added `format`
- Follows personnummer spec.

## 1.0.2

- Fix package issue with changelog.

## 1.0.1

- Add changelog
- Add example
- Use `isEmpty` instead of `length == 0`

## 1.0.0

- Initial version
