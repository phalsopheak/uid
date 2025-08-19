import 'package:flutter_test/flutter_test.dart';
import 'package:uid/uid.dart';

void main() {
  group('UId Tests', () {
    group('getId() basic functionality', () {
      test('should generate non-empty ID', () {
        final id = UId.getId();
        expect(id, isNotEmpty);
      });

      test('should generate different IDs on subsequent calls', () {
        final id1 = UId.getId();
        final id2 = UId.getId();
        expect(id1, isNot(equals(id2)));
      });
    });

    group('quantityOfRandomString parameter', () {
      test('should accept valid range (2-5)', () {
        for (int i = 2; i <= 5; i++) {
          expect(() => UId.getId(quantityOfRandomString: i), returnsNormally);
        }
      });

      test('should throw ArgumentError for values below 2', () {
        expect(() => UId.getId(quantityOfRandomString: 1), throwsA(isA<ArgumentError>()));
        expect(() => UId.getId(quantityOfRandomString: 0), throwsA(isA<ArgumentError>()));
        expect(() => UId.getId(quantityOfRandomString: -1), throwsA(isA<ArgumentError>()));
      });

      test('should throw ArgumentError for values above 5', () {
        expect(() => UId.getId(quantityOfRandomString: 6), throwsA(isA<ArgumentError>()));
        expect(() => UId.getId(quantityOfRandomString: 10), throwsA(isA<ArgumentError>()));
      });

      test('should generate correct length with different quantities', () {
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

        for (int quantity = 2; quantity <= 5; quantity++) {
          final id = UId.getId(quantityOfRandomString: quantity);
          expect(id.length, equals(timestamp.length + quantity));
        }
      });
    });

    group('isCapital parameter', () {
      test('should generate only uppercase letters and numbers when true', () {
        for (int i = 0; i < 10; i++) {
          final id = UId.getId(isCapital: true, quantityOfRandomString: 5);
          final nonDigits = id.replaceAll(RegExp(r'[0-9]'), '');
          // All non-digit characters should be uppercase
          expect(nonDigits, equals(nonDigits.toUpperCase()));
          // Should not contain lowercase letters
          expect(id, isNot(contains(RegExp(r'[a-z]'))));
        }
      });

      test('should allow lowercase when false (default)', () {
        bool foundLowercase = false;
        // Try multiple times to increase chance of getting lowercase
        for (int i = 0; i < 50; i++) {
          final id = UId.getId(isCapital: false, quantityOfRandomString: 5);
          if (id.contains(RegExp(r'[a-z]'))) {
            foundLowercase = true;
            break;
          }
        }
        // Note: This might occasionally fail due to randomness, but very unlikely with 50 attempts
        expect(foundLowercase, isTrue, reason: 'Should generate lowercase letters when isCapital is false');
      });
    });

    group('onlyNumbers parameter', () {
      test('should generate only numbers in random part when true', () {
        for (int i = 0; i < 10; i++) {
          final id = UId.getId(onlyNumbers: true, quantityOfRandomString: 3);
          // Should not contain any letters
          expect(id, isNot(contains(RegExp(r'[a-zA-Z]'))));
          // Should only contain digits
          expect(id, matches(RegExp(r'^[0-9]+$')));
        }
      });

      test('should allow letters when false (default)', () {
        bool foundLetter = false;
        // Try multiple times to increase chance of getting letters
        for (int i = 0; i < 50; i++) {
          final id = UId.getId(onlyNumbers: false, quantityOfRandomString: 5);
          if (id.contains(RegExp(r'[a-zA-Z]'))) {
            foundLetter = true;
            break;
          }
        }
        expect(foundLetter, isTrue, reason: 'Should generate letters when onlyNumbers is false');
      });
    });

    group('parameter combinations', () {
      test('should handle isCapital=true and onlyNumbers=true (onlyNumbers takes precedence)', () {
        for (int i = 0; i < 10; i++) {
          final id = UId.getId(isCapital: true, onlyNumbers: true, quantityOfRandomString: 4);
          // Should only contain digits (onlyNumbers overrides isCapital)
          expect(id, matches(RegExp(r'^[0-9]+$')));
        }
      });

      test('should handle all parameters together', () {
        final id = UId.getId(quantityOfRandomString: 4, isCapital: true, onlyNumbers: false);
        expect(id, isNotEmpty);
        expect(id.length, greaterThan(16)); // timestamp + 4 chars
      });
    });

    group('getMultipleIds functionality', () {
      test('should generate requested number of IDs', () {
        final ids = UId.getMultipleIds(count: 5);
        expect(ids.length, equals(5));
      });

      test('should generate unique IDs', () {
        final ids = UId.getMultipleIds(count: 10);
        final uniqueIds = Set<String>.from(ids);
        expect(uniqueIds.length, equals(ids.length));
      });

      test('should throw ArgumentError for count < 1', () {
        expect(() => UId.getMultipleIds(count: 0), throwsA(isA<ArgumentError>()));
        expect(() => UId.getMultipleIds(count: -1), throwsA(isA<ArgumentError>()));
      });

      test('should respect all parameters', () {
        final ids = UId.getMultipleIds(count: 3, quantityOfRandomString: 3, onlyNumbers: true);
        expect(ids.length, equals(3));
        for (final id in ids) {
          expect(id, matches(RegExp(r'^[0-9]+$')));
        }
      });
    });

    group('edge cases and robustness', () {
      test('should handle rapid successive calls', () {
        final ids = <String>[];
        for (int i = 0; i < 100; i++) {
          ids.add(UId.getId());
        }
        final uniqueIds = Set<String>.from(ids);
        // Should have high uniqueness ratio (allowing for very small chance of collision)
        expect(uniqueIds.length / ids.length, greaterThan(0.95));
      });

      test('should maintain consistent format across multiple calls', () {
        for (int i = 0; i < 20; i++) {
          final id = UId.getId(quantityOfRandomString: 3);
          // Should always be numeric string (digits only)
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          expect(id.length, equals(timestamp.length + 3));
        }
      });

      test('should work with minimum parameters', () {
        final id = UId.getId(quantityOfRandomString: 2);
        expect(id, isNotEmpty);
        expect(id.length, greaterThan(14)); // At least timestamp + 2 chars
      });

      test('should work with maximum parameters', () {
        final id = UId.getId(quantityOfRandomString: 5);
        expect(id, isNotEmpty);
        expect(id.length, greaterThan(17)); // At least timestamp + 5 chars
      });
    });

    group('performance tests', () {
      test('should generate IDs efficiently', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          UId.getId();
        }

        stopwatch.stop();
        // Should generate 1000 IDs in reasonable time (less than 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });
  });
}
