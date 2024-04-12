import 'package:flutter/material.dart';

class BookReportWritingScreen extends StatelessWidget {
  const BookReportWritingScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      childAspectRatio: 8.0 / 9.0,
      children: <Widget>[
        _buildCard(context, '독후감'),
        _buildCard(context, '한줄평'),
        _buildCard(context, '인용문구'),
        _buildCard(context, '퀴즈'),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.network(
                'https://via.placeholder.com/60x86',
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
