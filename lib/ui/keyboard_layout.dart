
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme_colors.dart';

class _KeyInfo {
  String topLeft;
  String topRight;
  String bottomLeft;
  String bottomRight;

  _KeyInfo({this.topLeft, this.topRight, this.bottomLeft, this.bottomRight});
}

enum KeyboardType {
  Korean,
  Japanese,
}

List<List<_KeyInfo>> koreanKeyboard = [
  [
    _KeyInfo(bottomLeft: 'Q', topLeft: 'ㅃ', topRight: 'ㅂ'),
    _KeyInfo(bottomLeft: 'W', topLeft: 'ㅉ', topRight: 'ㅈ'),
    _KeyInfo(bottomLeft: 'E', topLeft: 'ㄸ', topRight: 'ㄷ'),
    _KeyInfo(bottomLeft: 'R', topLeft: 'ㄲ', topRight: 'ㄱ'),
    _KeyInfo(bottomLeft: 'T', topLeft: 'ㅆ', topRight: 'ㅅ'),
    _KeyInfo(bottomLeft: 'Y', topLeft: '', topRight: 'ㅛ'),
    _KeyInfo(bottomLeft: 'U', topLeft: '', topRight: 'ㅕ'),
    _KeyInfo(bottomLeft: 'I', topLeft: '', topRight: 'ㅑ'),
    _KeyInfo(bottomLeft: 'O', topLeft: 'ㅒ', topRight: 'ㅐ'),
    _KeyInfo(bottomLeft: 'P', topLeft: 'ㅖ', topRight: 'ㅔ'),
  ],
  [
    _KeyInfo(bottomLeft: 'A', topLeft: '', topRight: 'ㅁ'),
    _KeyInfo(bottomLeft: 'S', topLeft: '', topRight: 'ㄴ'),
    _KeyInfo(bottomLeft: 'D', topLeft: '', topRight: 'ㅇ'),
    _KeyInfo(bottomLeft: 'F', topLeft: '', topRight: 'ㄹ'),
    _KeyInfo(bottomLeft: 'G', topLeft: '', topRight: 'ㅎ'),
    _KeyInfo(bottomLeft: 'H', topLeft: '', topRight: 'ㅗ'),
    _KeyInfo(bottomLeft: 'J', topLeft: '', topRight: 'ㅓ'),
    _KeyInfo(bottomLeft: 'K', topLeft: '', topRight: 'ㅏ'),
    _KeyInfo(bottomLeft: 'L', topLeft: '', topRight: 'ㅣ'),
    _KeyInfo(bottomLeft: ';', topLeft: '', topRight: ''),
  ],
  [
    _KeyInfo(bottomLeft: 'Z', topLeft: '', topRight: 'ㅋ'),
    _KeyInfo(bottomLeft: 'X', topLeft: '', topRight: 'ㅌ'),
    _KeyInfo(bottomLeft: 'C', topLeft: '', topRight: 'ㅊ'),
    _KeyInfo(bottomLeft: 'V', topLeft: '', topRight: 'ㅍ'),
    _KeyInfo(bottomLeft: 'B', topLeft: '', topRight: 'ㅠ'),
    _KeyInfo(bottomLeft: 'N', topLeft: '', topRight: 'ㅜ'),
    _KeyInfo(bottomLeft: 'M', topLeft: '', topRight: 'ㅡ'),
    _KeyInfo(bottomLeft: ',', topLeft: '', topRight: ''),
    _KeyInfo(bottomLeft: '.', topLeft: '', topRight: ''),
    _KeyInfo(bottomLeft: '/', topLeft: '', topRight: ''),
  ],
];

class KeyboardLayout extends StatelessWidget {
  
  final KeyboardType keyboardType;

  final Function(String) onReceiveCharacter;

  const KeyboardLayout(this.keyboardType, {Key key, this.onReceiveCharacter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeColors.white,
        height: 230,
        child: Column(
            children: keyInfosList.map((keyList) {
              return Expanded(child: buildKeyboardRow(context, keyList));
            }).toList()
        )
    );
  }

  List<List<_KeyInfo>> get keyInfosList {
    switch(keyboardType) {
      case KeyboardType.Korean:
        return koreanKeyboard;
      default:
        return koreanKeyboard;
    }
  }

  Widget buildKeyboardLayout(BuildContext context, List<List<_KeyInfo>> keyInfosList) {
    return Container(
        color: ThemeColors.white,
        height: 230,
        child: Column(
            children: keyInfosList.map((keyList) {
              return Expanded(child: buildKeyboardRow(context, keyList));
            }).toList()
        )
    );
  }

  Widget buildKeyboardRow(BuildContext context, List<_KeyInfo> keyInfos) {
    return Row(
      children: keyInfos.map(
              (keyInfo) => Expanded(child: buildKey(context, keyInfo))
      ).toList(),
    );
  }

  Widget buildKey(BuildContext context, _KeyInfo keyInfo) {
    return Material(
      child: InkWell(
        onTap: () => onReceiveCharacter(keyInfo.topRight),
        onLongPress: () => onReceiveCharacter(keyInfo.topLeft),
        child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: ThemeColors.blue.withAlpha(200),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          keyInfo.bottomLeft,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          keyInfo.topRight,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
                        ),
                      ),
                    ),
                    if (keyInfo.topLeft != '') Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          keyInfo.topLeft,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
