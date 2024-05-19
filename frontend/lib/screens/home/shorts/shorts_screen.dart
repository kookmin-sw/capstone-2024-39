import 'package:flutter/material.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsState();
}

class _ShortsState extends State<ShortsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '쇼츠 들어갈 페이지',
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}

