import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'data_models.dart';

Future<List<VocabInfo>> loadBeginnerVocab() async {
  final fileString = await rootBundle.loadString('assets/files/beginner.txt');
  return parseFileString(fileString);
}

Future<List<VocabInfo>> loadIntermediateVocab() async {
  final fileString = await rootBundle.loadString('assets/files/intermediate.txt');
  return parseFileString(fileString);
}

List<VocabInfo> parseFileString(String content) =>
    content.split('\r\n').map((line) {
      final items = line.split(',').toList();
      if(items.length == 1) return VocabInfo(items[0]);
      return VocabInfo(items[0], relatedContent: items[1], genre: items[2]);
    }).toList();
