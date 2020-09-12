import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:korean_typing_game/ui/game_page.dart';
import 'package:korean_typing_game/util.dart';

import '../data_models.dart';

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
          _buildListItem(context, 'Korean Character', 'Characters', _characters),
          _buildListItem(context, 'Korean Beginner Vocabulary', 'Beginner Vocabulary', _beginnerVocabList, characterLimit: 1),
          _buildListItem(context, 'Korean Beginner Vocabulary', 'Beginner Vocabulary', _beginnerVocabList, characterLimit: 2),
          _buildListItem(context, 'Korean Beginner Vocabulary', 'Beginner Vocabulary', _beginnerVocabList, characterLimit: 3),
          _buildListItem(context, 'Korean Beginner Vocabulary', 'Beginner Vocabulary', _beginnerVocabList),
          _buildListItem(context, 'Korean Intermediate Vocabulary', 'Intermediate Vocab', _intermediateVocabList, characterLimit: 1),
          _buildListItem(context, 'Korean Intermediate Vocabulary', 'Intermediate Vocab', _intermediateVocabList, characterLimit: 2),
          _buildListItem(context, 'Korean Intermediate Vocabulary', 'Intermediate Vocab', _intermediateVocabList, characterLimit: 3),
          _buildListItem(context, 'Korean Intermediate Vocabulary', 'Intermediate Vocab', _intermediateVocabList),
        ],
      )
    );
  }

  Widget _buildListItem(BuildContext context, String itemTitle, String pageTitle, List<VocabInfo> vocabs, {int characterLimit}) {
    List<VocabInfo> list = vocabs;
    String title = itemTitle;
    if (characterLimit != null) {
      list = vocabs.where((info) => info.word.length == characterLimit).toList();
      title += ': $characterLimit characters';
    }

    return Card(
        child: ListTile(
          onTap: () => GamePage.navigateTo(context, pageTitle, list),
          title: Text(title),
        ),
      );
  }
}
