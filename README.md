<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Generate a unique ID from datetime, convert it to millisecondsSinceEpoch, and combine it with a random position and a string.

## Getting started

Pubspec yaml:

```yaml
dependencies:
  uid: ^0.0.1
```

Import the package:

```dart
import 'package:uid/uid.dart';
```

## Usage

```dart
//Get unique id from current datetime then convert to milisecond
//and split it at random position and add random string.
//Ex: 4824254606141 quantityOfRandomString=2
//random postion at 4 => 4824 + aF + 254606141
//return 4824aF254606141

var id = UId.getId();//4824 aF 254606141 => 4824aF254606141

var id1 = UId.getId(4); //4824 aZ2F 254606141 => 4824aZ2F254606141
```


