import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:korean_typing_game/game_page.dart';
import 'package:korean_typing_game/util.dart';

import 'data_models.dart';

class VocabListPage extends StatefulWidget {
  @override
  _VocabListPageState createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {

  List<VocabInfo> _beginnerVocabList;
  List<VocabInfo> _intermediateVocabList;

  List<VocabInfo> _characters = ['ㅂ','ㅈ','ㄷ','ㄱ','ㅅ','ㅛ','ㅕ','ㅑ','ㅐ','ㅔ','ㅁ','ㄴ','ㅇ','ㄹ','ㅎ','ㅗ','ㅓ','ㅏ','ㅏ','ㅣ','ㅋ','ㅌ','ㅊ','ㅍ','ㅠ','ㅜ','ㅡ','ㅃ','ㅉ','ㄸ','ㄲ','ㅆ','ㅒ','ㅖ',]
      .map((char) => VocabInfo(char))
      .toList();

  @override
  void initState() {
    super.initState();

    loadBeginnerVocab().then((list) {
      _beginnerVocabList = list;
      setState(() { });
    });

    loadIntermediateVocab().then((list) {
      _intermediateVocabList = list;
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vocabulary List')),
      body: Column(
        children: [
           Card(
             child: ListTile(
               onTap: () => GamePage.navigateTo(context, 'Characters', _characters),
               title: Text('Korean Character'),
             ),
           ),
          Card(
            child: ListTile(
              onTap: () => GamePage.navigateTo(context, 'Beginner Vocab', _beginnerVocabList),
              title: Text('Korean Beginner Vocabulary'),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () => GamePage.navigateTo(context, 'Intermediate Vocab', _intermediateVocabList),
              title: Text('Korean Intermediate Vocabulary'),
            ),
          ),
        ],
      )
    );
  }
}
