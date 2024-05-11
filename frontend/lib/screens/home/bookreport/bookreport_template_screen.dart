import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookReportTemplateScreen extends StatelessWidget {
  const BookReportTemplateScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글쓰기'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Noto Sans KR',
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        backgroundColor: const Color(0xFF0E9913),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 8.0 / 9.0,
        children: <Widget>[
          _buildCard(context, '독후감'),
          _buildCard(context, '한줄평'),
          _buildCard(context, '인용문구'),
          _buildCard(context, '퀴즈'),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String template) {
    int index = 0;
    if (template == '퀴즈') {
      index = 999;
    } else if (template == '인용문구') {
      index = 998;
    } else if (template == '한줄평') {
      index = 997;
    } else if (template == '독후감') {
      index = 996;
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/bookreport_writing', extra: index),
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
                template,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
