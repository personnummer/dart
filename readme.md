# personnummer [![Build Status](https://travis-ci.org/personnummer/dart.svg?branch=master)](https://travis-ci.org/personnummer/dart)

Validate Swedish social security numbers.

## Example

```dart
import 'package:personnummer/personnummer.dart';

Personnummer.valid(8507099805);
//=> true

Personnummer.valid('198507099805');
//=> true
```

See [test/personnummer.dart](test/personnummer.dart) for more examples.

## License

MIT