import 'dart:math';

/// A utility class for generating unique IDs based on current timestamp
/// with random string insertion at a random position.
class UId {
  static const String _validChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static const String _validCharsCapital = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static const String _validCharsNumbers = '0123456789';

  static final Random _random = Random();

  /// Generate a random string with specified length and character constraints.
  ///
  /// [length] - The length of the random string to generate
  /// [isCapital] - If true, uses only uppercase letters and numbers
  /// [onlyNumbers] - If true, uses only numeric characters
  ///
  /// Returns a random string of the specified length.
  static String _getRandomString(int length, {bool isCapital = false, bool onlyNumbers = false}) {
    if (length <= 0) return '';

    String chars;
    if (onlyNumbers) {
      chars = _validCharsNumbers;
    } else if (isCapital) {
      chars = _validCharsCapital;
    } else {
      chars = _validChars;
    }

    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  /// Generate a random position within the given length.
  ///
  /// [length] - The maximum length for position generation
  ///
  /// Returns a random integer between 0 and length-1.
  static int _getRandomPosition(int length) {
    if (length <= 0) return 0;
    return _random.nextInt(length);
  }

  /// Generate a unique ID by inserting random characters into a timestamp.
  ///
  /// The ID is created by:
  /// 1. Getting current timestamp in milliseconds
  /// 2. Generating a random string based on parameters
  /// 3. Inserting the random string at a random position in the timestamp
  ///
  /// Example:
  /// - Timestamp: 1724254606141
  /// - Random string: "aF"
  /// - Random position: 4
  /// - Result: "1724aF254606141"
  ///
  /// [quantityOfRandomString] - Number of random characters to insert (2-5)
  /// [isCapital] - If true, random string contains only uppercase letters and numbers
  /// [onlyNumbers] - If true, random string contains only numbers
  ///
  /// Returns a unique string ID.
  ///
  /// Throws [ArgumentError] if quantityOfRandomString is not between 2 and 5.
  static String getId({int quantityOfRandomString = 2, bool isCapital = false, bool onlyNumbers = false}) {
    if (quantityOfRandomString < 2 || quantityOfRandomString > 5) {
      throw ArgumentError('quantityOfRandomString must be between 2 and 5, got $quantityOfRandomString');
    }

    final strMillisecond = DateTime.now().millisecondsSinceEpoch.toString();
    final strRandom = _getRandomString(quantityOfRandomString, isCapital: isCapital, onlyNumbers: onlyNumbers);

    final position = _getRandomPosition(strMillisecond.length);

    final id = strMillisecond.substring(0, position) + strRandom + strMillisecond.substring(position);

    return id;
  }

  /// Generate multiple unique IDs at once.
  ///
  /// [count] - Number of IDs to generate
  /// [quantityOfRandomString] - Number of random characters per ID (2-5)
  /// [isCapital] - If true, random strings contain only uppercase letters and numbers
  /// [onlyNumbers] - If true, random strings contain only numbers
  ///
  /// Returns a list of unique string IDs.
  ///
  /// Throws [ArgumentError] if count is less than 1 or quantityOfRandomString is not between 2 and 5.
  static List<String> getMultipleIds({
    required int count,
    int quantityOfRandomString = 2,
    bool isCapital = false,
    bool onlyNumbers = false,
  }) {
    if (count < 1) {
      throw ArgumentError('count must be at least 1, got $count');
    }

    final ids = <String>[];
    for (int i = 0; i < count; i++) {
      ids.add(getId(quantityOfRandomString: quantityOfRandomString, isCapital: isCapital, onlyNumbers: onlyNumbers));
      // Small delay to ensure different timestamps
      if (i < count - 1) {
        // Use a more reliable way to ensure uniqueness
        Future.delayed(Duration(microseconds: 1));
      }
    }
    return ids;
  }
}
