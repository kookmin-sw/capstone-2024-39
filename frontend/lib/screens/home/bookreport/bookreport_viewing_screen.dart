import 'package:flutter/material.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

class BookReportViewingScreen extends StatefulWidget {
  final String type;
  final dynamic contentData;

  const BookReportViewingScreen({
    super.key,
    required this.type,
    required this.contentData,
  });

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
  String _author = "작가";
  String _publisher = "출판사";
  // ignore: prefer_typing_uninitialized_variables
  var token;

  void initializeContentData(dynamic token) async {
    _contentData = await contentLoad(token, 2);
    _template = contentTypeCheck(_contentData[0]['type'] as String);
    _title = _contentData[0]['title'] as String;
    _body = _contentData[0]['body'] as String;
  }

  void initializeClubContentData(dynamic content){
    
    setState(() {
      _template = contentTypeCheck(content['type']);
      _title = content['title'];
      _body = content['body'];
      _author = content['book']['author'];
      _publisher = content['book']['publisher'];
    });
  }

  String contentTypeCheck(String template){ 
    switch (template) {
      case "Review":
        return "독후감";
      case "ShortReview":
        return "한줄평";
      case "Quotation":
        return "인용구";
      case "MultipleChoice":
        return "객관식";
      case "ShortAnswer":
        return "단답식";
      case "OX":
        return "OX";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _initUserState();
    switch (widget.type) {
      case 'club':
        initializeClubContentData(widget.contentData);
        break;
      case 'bookInfo':
        initializeContentData(token);
        break;

      default:
        break;
    }
    
  }

  Future<void> _initUserState() async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    token = await secureStorage.readData("token");
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
          fontSize: 20,
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
      case "인용구":
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
