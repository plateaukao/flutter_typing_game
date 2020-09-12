import 'dart:io';

import 'package:flutter/material.dart';
import 'package:korean_typing_game/theme_colors.dart';
import 'package:korean_typing_game/ui/vocab_list_page.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Typing Game");
    setWindowMinSize(Size(1024, 768));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: ThemeColors.darkBlue,
        scaffoldBackgroundColor: ThemeColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: GamePage(title: 'Korean Typing Game'),
      home: VocabListPage(),
    );
  }
}

