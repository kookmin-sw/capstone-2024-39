import 'package:flutter/material.dart';
import 'package:frontend/http.dart';
import 'package:frontend/screens/home/search/search_screen.dart';

class BookReportViewingScreen extends StatefulWidget {
  const BookReportViewingScreen({super.key});

  @override
  State<BookReportViewingScreen> createState() => _BookReportViewingState();
}

class _BookReportViewingState extends State<BookReportViewingScreen> {
  List<dynamic> _contentData = [];
  //DateTime _startDate = DateTime.now();
  //DateTime _endDate = DateTime.now();
  //bool _isPublic = false;
  String _template = '';
  String _title = '';
  String _body = '';
  final String _author = "작가";
  final String _publisher = "출판사";

  void initializeContentData(dynamic token) async {
    _contentData = await contentLoad(token[0], 1);
    _template = _contentData[0]['type'] as String;
    _title = _contentData[0]['title'] as String;
    _body = _contentData[0]['body'] as String;
  }

  @override
  void initState() {
    super.initState();
    initializeContentData(token);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_template),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Noto Sans KR',
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: const Color(0xFF0E9913),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(_title),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('$_author | $_publisher',
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFA9AFB7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Expanded(
                child: _buildTemplateUI(_template),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateUI(String template) {
    switch (template) {
      case "독후감":
        return Text(_body);
      case "한줄평":
        return Text(_body);
      case "인용문구":
        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  _body,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                ),
              ),
              const Positioned(
                left: 0,
                top: 0,
                child: Icon(Icons.format_quote),
              ),
              const Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.format_quote),
              ),
            ],
          ),
        );
      default:
        throw ArgumentError('Invalid template type');
    }
  }
}
