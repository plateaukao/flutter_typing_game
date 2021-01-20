
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
        height: 230,
        color: ThemeColors.grey,
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

  Widget buildKeyboardRow(BuildContext context, List<_KeyInfo> keyInfos) => Row(
      children: keyInfos.map((keyInfo) => Expanded(child: buildKey(context, keyInfo))).toList(),
    );

  Widget buildKey(BuildContext context, _KeyInfo keyInfo) {
    final padding = 6.0;
    return Material(
      color: ThemeColors.grey,
      child: InkWell(
        onTap: () => onReceiveCharacter(keyInfo.topRight),
        onLongPress: () => onReceiveCharacter(keyInfo.topLeft),
        child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                decoration: new BoxDecoration(
                  color: ThemeColors.black.withAlpha(200),
                  borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
                ),
                child: Stack(
                  children: [
                    buildBottomLeftChar(context, padding, keyInfo),
                    buildTopRightChar(context, padding, keyInfo),
                    buildTopLeftChar(context, padding, keyInfo),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget buildBottomLeftChar(BuildContext context, double padding, _KeyInfo keyInfo) => Padding(
      padding: EdgeInsets.all(padding),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          keyInfo.bottomLeft,
          style: Theme.of(context).textTheme.headline5.copyWith(color: ThemeColors.white),
        ),
      ),
    );

  Widget buildTopRightChar(BuildContext context, double padding, _KeyInfo keyInfo) => Padding(
      padding: EdgeInsets.all(padding),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
            keyInfo.topRight,
            style: Theme.of(context).textTheme.headline6.copyWith(color: ThemeColors.white)),
      ),
    );

  Widget buildTopLeftChar(BuildContext context, double padding, _KeyInfo keyInfo) => (keyInfo.topLeft != '')? Padding(
      padding: EdgeInsets.all(padding),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
            keyInfo.topLeft,
            style: Theme.of(context).textTheme.headline6.copyWith(color: ThemeColors.white)),
      ),
    ) : SizedBox.shrink();
}
