import 'dart:math';

class UId {
  static const String _validChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';

  static final Random _random = Random();

  ///Get random string from AaBb....Zz1234567890
  ///
  ///Ex: _getRandomString(2) ==> ag,gd,Dd,dE,z4...
  static String _getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _validChars.codeUnitAt(_random.nextInt(_validChars.length)),
      ),
    );
  }

  static int _getRandomPosition(int length) {
    return _random.nextInt(length);
  }

  ///Get unique id from current datetime then convert to milisecond
  ///and split it at random position and add random string
  ///
  ///Ex: 4824254606141 quantityOfRandomString=2
  ///random postion at 4 => 4824 + aF + 254606141
  ///return 4824aF254606141
  static String getId({int quantityOfRandomString = 2}) {
    assert(quantityOfRandomString >= 2 && quantityOfRandomString <= 5,
        'quantityOfRandomString should be between 2 and 5');

    var strMiliSecond = DateTime.now().millisecondsSinceEpoch.toString();
    var strRandom = _getRandomString(quantityOfRandomString);

    var position = _getRandomPosition(strMiliSecond.length);

    var id = strMiliSecond.substring(0, position) +
        strRandom +
        strMiliSecond.substring(position);

    return id;
  }
}
