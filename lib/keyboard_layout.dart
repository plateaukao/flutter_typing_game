
class KeyInfo {
  String topLeft;
  String topRight;
  String bottomLeft;
  String bottomRight;

  KeyInfo({this.topLeft, this.topRight, this.bottomLeft, this.bottomRight});
}

List<List<KeyInfo>> koreanKeyboard = [
  [
    KeyInfo(bottomLeft: 'Q', topLeft: 'ㅃ', topRight: 'ㅂ'),
    KeyInfo(bottomLeft: 'W', topLeft: 'ㅉ', topRight: 'ㅈ'),
    KeyInfo(bottomLeft: 'E', topLeft: 'ㄸ', topRight: 'ㄷ'),
    KeyInfo(bottomLeft: 'R', topLeft: 'ㄲ', topRight: 'ㄱ'),
    KeyInfo(bottomLeft: 'T', topLeft: 'ㅆ', topRight: 'ㅅ'),
    KeyInfo(bottomLeft: 'Y', topLeft: '', topRight: 'ㅛ'),
    KeyInfo(bottomLeft: 'U', topLeft: '', topRight: 'ㅕ'),
    KeyInfo(bottomLeft: 'I', topLeft: '', topRight: 'ㅑ'),
    KeyInfo(bottomLeft: 'O', topLeft: 'ㅒ', topRight: 'ㅐ'),
    KeyInfo(bottomLeft: 'P', topLeft: 'ㅖ', topRight: 'ㅔ'),
  ],
  [
    KeyInfo(bottomLeft: 'A', topLeft: '', topRight: 'ㅁ'),
    KeyInfo(bottomLeft: 'S', topLeft: '', topRight: 'ㄴ'),
    KeyInfo(bottomLeft: 'D', topLeft: '', topRight: 'ㅇ'),
    KeyInfo(bottomLeft: 'F', topLeft: '', topRight: 'ㄹ'),
    KeyInfo(bottomLeft: 'G', topLeft: '', topRight: 'ㅎ'),
    KeyInfo(bottomLeft: 'H', topLeft: '', topRight: 'ㅗ'),
    KeyInfo(bottomLeft: 'J', topLeft: '', topRight: 'ㅓ'),
    KeyInfo(bottomLeft: 'K', topLeft: '', topRight: 'ㅏ'),
    KeyInfo(bottomLeft: 'L', topLeft: '', topRight: 'ㅣ'),
    KeyInfo(bottomLeft: ';', topLeft: '', topRight: ''),
  ],
  [
    KeyInfo(bottomLeft: 'Z', topLeft: '', topRight: 'ㅋ'),
    KeyInfo(bottomLeft: 'X', topLeft: '', topRight: 'ㅌ'),
    KeyInfo(bottomLeft: 'C', topLeft: '', topRight: 'ㅊ'),
    KeyInfo(bottomLeft: 'V', topLeft: '', topRight: 'ㅍ'),
    KeyInfo(bottomLeft: 'B', topLeft: '', topRight: 'ㅠ'),
    KeyInfo(bottomLeft: 'N', topLeft: '', topRight: 'ㅜ'),
    KeyInfo(bottomLeft: 'M', topLeft: '', topRight: 'ㅡ'),
    KeyInfo(bottomLeft: ',', topLeft: '', topRight: ''),
    KeyInfo(bottomLeft: '.', topLeft: '', topRight: ''),
    KeyInfo(bottomLeft: '/', topLeft: '', topRight: ''),
  ],
];