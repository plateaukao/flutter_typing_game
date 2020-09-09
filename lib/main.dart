import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:korean_typing_game/theme_colors.dart';

import 'keyboard_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: ThemeColors.darkBlue,
        scaffoldBackgroundColor: ThemeColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GamePage(title: 'Korean Typing Game'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const double _wordInterval = 50;
  static const int _practiceNumbers = 5;

  final rng = new Random();

  List<String> _allWords= ['ㅂ','ㅈ','ㄷ','ㄱ','ㅅ','ㅛ','ㅕ','ㅑ','ㅐ','ㅔ','ㅁ','ㄴ','ㅇ','ㄹ','ㅎ','ㅗ','ㅓ','ㅏ','ㅏ','ㅣ','ㅋ','ㅌ','ㅊ','ㅍ','ㅠ','ㅜ','ㅡ','ㅃ','ㅉ','ㄸ','ㄲ','ㅆ','ㅒ','ㅖ',];

  List<WordInfo> _wordInfos;

  double screenWidth;
  double screenHeight;

  int missCount = 0;
  int hitCount = 0;

  final myController = TextEditingController();

  final gameAreaKey = GlobalKey();

  Timer _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenWidth = MediaQuery.of(context).size.width;

    double top = -_wordInterval * _practiceNumbers;

    _allWords.shuffle();

    _wordInfos = _allWords.take(_practiceNumbers).map(
            (word) {
          top += _wordInterval;
          return WordInfo(word, top, rng.nextInt(300).toDouble());
        }
    ).toList();

    _timer ??= Timer.periodic(
      Duration(milliseconds: 20),
          (Timer t) => setState((){
        updateWordInfos();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Center(child: Text('$hitCount / $missCount')),
        actions: [
          IconButton(
              icon: Icon(Icons.rotate_left),
              onPressed: () {
                setState(() {
                  missCount = 0;
                  hitCount = 0;
                });
              },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              key: gameAreaKey,
                children: _wordInfos.map(
                          (wordInfo) => Positioned(
                        top: wordInfo.top,
                        left: wordInfo.left,
                        child: Text(
                          wordInfo.word,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      )
                  ).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              autofocus: true,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ThemeColors.blue, width: 3.0),
                ),
                hintText: 'Input here',
              ),
              controller: myController,
              onChanged: _textChanged,
            ),
          ),
          if (Platform.isMacOS) buildKeyboardLayout(koreanKeyboard),
        ],
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  double _getGameAreaHeight() {
    final RenderBox renderBoxRed = gameAreaKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    return sizeRed.height;
  }

  void updateWordInfos() {
    if (screenHeight == null) screenHeight = _getGameAreaHeight();

    for (var wordInfo in _wordInfos) {
      wordInfo.top += 1;
      if (wordInfo.top >= screenHeight) {
        missCount++;
        _wordInfos.remove(wordInfo);
        addNewWordInfo();
      }
    }
  }

  void addNewWordInfo() {
    final newWord = _allWords[rng.nextInt(_allWords.length)];

    _wordInfos.add(
      WordInfo(
        newWord,
          -_wordInterval,
          rng.nextInt(screenWidth.toInt() - 100).toDouble(),
      )
    );
  }

  void _textChanged(String text) {
    final matchedWordInfo = _wordInfos.firstWhere((element) => element.word == text);
    if (matchedWordInfo != null) {
      hitCount++;
      _wordInfos.remove(matchedWordInfo);
      addNewWordInfo();
      myController.text = '';
    }
  }

  Widget buildKeyboardLayout(List<List<KeyInfo>> keyInfos) {
    return Container(
      color: ThemeColors.white,
      height: 230,
      child: Column(
          children: keyInfos.map((keyList) {
            return Expanded(child: buildKeyboardRow(keyList));
          }).toList()
      )
    );
  }

  Widget buildKeyboardRow(List<KeyInfo> keyInfos) {
    return Row(
      children: keyInfos.map(
          (keyInfo) => Expanded(child: buildKey(keyInfo))
      ).toList(),
    );
  }

  Widget buildKey(KeyInfo keyInfo) {
    return Material(
      child: InkWell(
        onTap: () => _textChanged(keyInfo.topRight),
        onLongPress: () => _textChanged(keyInfo.topLeft),
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
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          keyInfo.topRight,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    if (keyInfo.topLeft != '') Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          keyInfo.topLeft,
                          style: Theme.of(context).textTheme.headline6,
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

class WordInfo {

  String word;
  double top;
  double left;

  WordInfo(this.word, this.top, this.left);
}

