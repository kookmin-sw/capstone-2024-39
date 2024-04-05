import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '검색 들어갈 페이지',
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}
