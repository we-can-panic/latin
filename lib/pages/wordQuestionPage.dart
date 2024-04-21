import 'package:flutter/material.dart';
import "../utils/latinutils.dart";
import "../utils/flutterutils.dart";

Column wordStartDivision(BuildContext context) {
  return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    SizedBox(height: 50),
    SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WordQuestion(title: "単語テスト")),
        );
      },
      child: const Text('単語テスト'),
    )
  ]);
}

class WordQuestion extends StatefulWidget {
  const WordQuestion({super.key, required this.title});
  final String title;

  @override
  State<WordQuestion> createState() => _WordQuestionState();
}

class _WordQuestionState extends State<WordQuestion> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポップなエフェクト'),
      ),
      body: const Center(
        child: PopEffect(),
      ),
    );
  }
}

class PopEffect extends StatefulWidget {
  const PopEffect({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PopEffectState createState() => _PopEffectState();
}

class _PopEffectState extends State<PopEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: const Text(
          '正解',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
