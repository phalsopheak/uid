## Unique ID Generator

A lightweight Dart package for generating unique IDs by inserting random strings into timestamps at random positions.
Features

🆔 Generate unique IDs based on current timestamp

🎲 Insert random characters at random positions

🔤 Support for different character sets (mixed case, uppercase only, numbers only)

⚡ Fast and efficient ID generation

🔢 Batch ID generation support


## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  uid: ^0.1.0
```

Import the package:

```dart
import 'package:uid/uid.dart';
```

## Usage

Basic Usage

```dart
import 'package:unique_id_generator/unique_id_generator.dart';

void main() {
  // Generate a basic unique ID
  String id = UId.getId();
  print(id); // Example: 4824aF254606141
}

```

Advanced Usage

```dart
import 'package:unique_id_generator/unique_id_generator.dart';

void main() {
  // Generate ID with custom random string length
  String id1 = UId.getId(quantityOfRandomString: 4);
  print(id1); // Example: 4824aBc3254606141

  // Generate ID with only uppercase letters and numbers
  String id2 = UId.getId(isCapital: true);
  print(id2); // Example: 4824AF254606141

  // Generate ID with only numbers
  String id3 = UId.getId(onlyNumbers: true);
  print(id3); // Example: 482434254606141

  // Combine parameters
  String id4 = UId.getId(
    quantityOfRandomString: 3,
    isCapital: true,
  );
  print(id4); // Example: 4824A2F254606141

  // Generate multiple IDs at once
  List<String> ids = UId.getMultipleIds(
    count: 5,
    quantityOfRandomString: 3,
    onlyNumbers: true,
  );
  print(ids); // Example: [482412354606141, 482435654606142, ...]
}

```


