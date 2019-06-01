# personnummer [![Build Status](https://travis-ci.org/personnummer/dart.svg?branch=master)](https://travis-ci.org/personnummer/dart)

> Work in progress

Validate Swedish social security numbers.

## Installation

```
TBA
```

## Examples

### Validation

```dart
import 'package:personnummer/personnummer.dart';

Personnummer.valid(6403273813);
//=> true

Personnummer.valid('19130401+2931');
//=> true
```

See [test/personnummer.dart](test/personnummer.dart) for more examples.

## License

MIT