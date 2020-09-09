import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
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

  final myController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    double top = -_wordInterval * _practiceNumbers;

    _allWords.shuffle();

    _wordInfos = _allWords.take(_practiceNumbers).map(
            (word) {
          top += _wordInterval;
          return WordInfo(word, top, rng.nextInt(300).toDouble());
        }
    ).toList();

    Timer.periodic(
      Duration(milliseconds: 15),
          (Timer t) => setState((){
        updateWordInfos();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text(widget.title)),
      body: Stack(
          children: [
            ..._wordInfos.map(
                    (wordInfo) => Positioned(
                  top: wordInfo.top,
                  left: wordInfo.left,
                  child: Text(
                    wordInfo.word,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                )
            ).toList(),
            Align(
              alignment: Alignment.bottomRight,
                child: TextField(
                  controller: myController,
                  onChanged: _textChanged,
                )
            ),
          ]
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void updateWordInfos() {
    for (var wordInfo in _wordInfos) {
      wordInfo.top += 1;
      if (wordInfo.top >= screenHeight) {
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
      _wordInfos.remove(matchedWordInfo);
      addNewWordInfo();
      myController.text = '';
    }
  }
}

class WordInfo {

  String word;
  double top;
  double left;

  WordInfo(this.word, this.top, this.left);
}

