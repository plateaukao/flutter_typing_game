import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

import '../data_models.dart';
import 'keyboard_layout.dart';
import '../theme_colors.dart';

class WordInfo {
  String word;
  double top;
  double left;

  WordInfo(this.word, this.top, this.left);
}

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

  WordInfo _hitWordInfo;
  Widget _effectWidget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    double top = -_wordInterval * _practiceNumbers;

    _allWords = widget.vocabInfos;
    _allWords.shuffle();

    _wordInfos = _allWords.take(_practiceNumbers).map(
            (vocab) {
          top += _wordInterval;
          return WordInfo(vocab.word, top, rng.nextInt(300).toDouble());
        }
    ).toList();

    _timer = _createTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()
        ),
        actions: [
          Center(child: Text('$hitCount / $missCount')),
          _buildRestartButton(),
          _buildGameControlButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              key: _gameAreaKey,
              children: [
                ..._wordInfos.map(_buildFallingItem).toList(),
                if (_hitWordInfo != null) _buildHitAnimation(_hitWordInfo),
              ],
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
          if (Platform.isMacOS) KeyboardLayout(KeyboardType.Korean, onReceiveCharacter: _textChanged),
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

  // ----------- UI elements -----------
  double _getGameAreaHeight() {
    final RenderBox renderBoxRed = _gameAreaKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    return sizeRed.height;
  }

  Widget _buildHitAnimation(WordInfo wordInfo) {
    _effectWidget ??= _buildEffectWidget(wordInfo);
    return Positioned(
      top: wordInfo.top,
      left: wordInfo.left,
      child: _effectWidget,
    );
  }

  Widget _buildEffectWidget(WordInfo wordInfo) {
    return PimpedButton(
      duration: const Duration(milliseconds: 300),
      particle: DemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        controller.addStatusListener((status) {
          if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
            setState(() {
              _hitWordInfo = null;
              _effectWidget = null;
            });
          }
        });
        controller.forward();
        return Text(_hitWordInfo.word, style: Theme.of(context).textTheme.headline2);
      },
    );
  }

  Widget _buildRestartButton() =>
      IconButton(
        icon: Icon(Icons.rotate_left),
        onPressed: () {
          setState(() {
            missCount = 0;
            hitCount = 0;
          });
        },
      );

  Widget _buildGameControlButton() =>
      IconButton(
        icon: _timer?.isActive == true ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        onPressed: () => setState(() {
            if (_timer?.isActive == true) {
              _timer.cancel();
              _timer = null;
            } else {
              _timer = _createTimer();
            }
          }),
      );


  Widget _buildFallingItem(WordInfo wordInfo) {
    return Positioned(
      top: wordInfo.top,
      left: wordInfo.left,
      child: Text(wordInfo.word, style: Theme.of(context).textTheme.headline2),
    );
  }

  // game logic
  void _updateWordInfos() {
    if (screenHeight == null) screenHeight = _getGameAreaHeight();

    for (var wordInfo in _wordInfos) {
      wordInfo.top += _dropDistance;
      if (wordInfo.top >= screenHeight) {
        missCount++;
        _wordInfos.remove(wordInfo);
        _addNewWordInfo();
      }
    }

    _hitWordInfo?.top += _dropDistance;
  }

  void _addNewWordInfo() {
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
    final matchedWordInfo = _wordInfos.firstWhere((element) => element.word == text, orElse: () => null);
    if (matchedWordInfo != null) {
      hitCount++;

      _wordInfos.remove(matchedWordInfo);
      setState(() {
        _hitWordInfo = matchedWordInfo;
      });

      _addNewWordInfo();
      _myController.text = '';
    }
  }

  Timer _createTimer() =>
      Timer.periodic(
        Duration(milliseconds: _updateInterval),
            (Timer t) {
          if (mounted) {
            setState(() => _updateWordInfos());
          }
        },
      );
}


