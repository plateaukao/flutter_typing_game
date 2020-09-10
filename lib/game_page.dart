
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data_models.dart';
import 'keyboard_layout.dart';
import 'theme_colors.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title, this.vocabInfos}) : super(key: key);

  final String title;

  final List<VocabInfo> vocabInfos;

  static void navigateTo(BuildContext context, String title, List<VocabInfo> vocabInfos) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage(title: title, vocabInfos: vocabInfos,)),
    );
  }


  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const double _wordInterval = 50;
  static const int _practiceNumbers = 5;
  static const int _updateInterval = 40;
  static const int _dropDistance = 1;

  final rng = new Random();

  List<VocabInfo> _allWords;

  List<WordInfo> _wordInfos;

  double screenWidth;
  double screenHeight;

  int missCount = 0;
  int hitCount = 0;

  final _myController = TextEditingController();

  final _gameAreaKey = GlobalKey();

  Timer _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenWidth = MediaQuery.of(context).size.width;

    double top = -_wordInterval * _practiceNumbers;

    _allWords = widget.vocabInfos;
    _allWords.shuffle();

    _wordInfos = _allWords.take(_practiceNumbers).map(
            (vocab) {
          top += _wordInterval;
          return WordInfo(vocab.word, top, rng.nextInt(300).toDouble());
        }
    ).toList();

    _timer ??= Timer.periodic(
      Duration(milliseconds: _updateInterval),
          (Timer t) {
            if (mounted) {
              setState(() => updateWordInfos());
            }
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text(widget.title)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()
        ),
        actions: [
        Center(child: Text('$hitCount / $missCount')),
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
              key: _gameAreaKey,
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
              controller: _myController,
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
    _myController.dispose();
    _timer.cancel();
    super.dispose();
  }

  double _getGameAreaHeight() {
    final RenderBox renderBoxRed = _gameAreaKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    return sizeRed.height;
  }

  void updateWordInfos() {
    if (screenHeight == null) screenHeight = _getGameAreaHeight();

    for (var wordInfo in _wordInfos) {
      wordInfo.top += _dropDistance;
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
          newWord.word,
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
      _myController.text = '';
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

