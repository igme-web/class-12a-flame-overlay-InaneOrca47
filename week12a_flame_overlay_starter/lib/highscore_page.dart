import 'package:flutter/material.dart';

class HighScorePage extends StatefulWidget {
  const HighScorePage({super.key});

  @override
  State<HighScorePage> createState() => _HighScorePageState();
}

class _HighScorePageState extends State<HighScorePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("High Scores")]
      )
    );
  }
}