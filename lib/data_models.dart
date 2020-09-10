
class WordInfo {
  String word;
  double top;
  double left;

  WordInfo(this.word, this.top, this.left);
}

class VocabInfo {
  String word;
  String relatedContent;
  String meaning;
  String genre;

  VocabInfo(this.word, {this.relatedContent, this.meaning, this.genre});
}
