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
  final TextEditingController _answerController = TextEditingController();
  List<dynamic> _contentData = [];
  //DateTime _startDate = DateTime.now();
  //DateTime _endDate = DateTime.now();
  //bool _isPublic = false;
  String _template = '퀴즈';
  String _title = '';
  String _body = '';
  String _author = "작가";
  String _publisher = "출판사";
  String _category = '단답형';
  String _answer = '';
  bool _oxanswer = false;
  String _example1 = '';
  String _example2 = '';
  String _example3 = '';
  String _example4 = '';
  bool _answer1 = false;
  bool _answer2 = false;
  bool _answer3 = false;
  bool _answer4 = false;
  // ignore: prefer_typing_uninitialized_variables
  var token;

  void initializeContentData(dynamic token) async {
    // _contentData = await contentLoad(token, 2);
    // _template = _contentData[0]['type'] as String;
    // _title = _contentData[0]['title'] as String;
    // _body = _contentData[0]['body'] as String;
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
      case "퀴즈":
        return Column(
          children: [
            Row(
              children: [
                const Text(
                  '카테고리: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.17,
                  ),
                ),
                const SizedBox(width: 3),
                SizedBox(
                  width: 121,
                  height: 22,
                  child: DropdownButton<String>(
                    value: _category,
                    onChanged: null,
                    items: <String>['단답형', '객관식', 'O/X']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 0,
                    ),
                    underline: Container(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Expanded(
                child: _buildQuizUI(_category),
              ),
            ),
          ],
        );
      default:
        throw ArgumentError('Invalid template type');
    }
  }

  Widget _buildQuizUI(String quizType) {
    switch (quizType) {
      case ("단답형"):
        return Column(
          children: [
            SizedBox(
              width: 350,
              height: 190,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 350,
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text('Q: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            //width: _screenWidth * 0.7,
                            child: Text(
                              _body,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('A: '),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      //width: _screenWidth * 0.7,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: _answerController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '답을 입력하세요',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case ("O/X"):
        return Column(
          children: [
            SizedBox(
              width: 350,
              height: 190,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 350,
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text('Q: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            //width: _screenWidth * 0.7,
                            child: Text(
                              _answer,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _oxanswer = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: _oxanswer ? Colors.green : Colors.white,
                      elevation: 0,
                      side: const BorderSide(width: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: const Size(140, 140),
                    ),
                    child: const Text('O'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _oxanswer = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: !_oxanswer ? Colors.green : Colors.white,
                      elevation: 0,
                      side: const BorderSide(width: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: const Size(140, 140),
                    ),
                    child: const Text('X'),
                  ),
                ],
              ),
            ),
          ],
        );
      case ("객관식"):
        return Column(
          children: [
            SizedBox(
              width: 350,
              height: 190,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 350,
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text('Q: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            //width: _screenWidth * 0.7,
                            child: Text(
                              _body,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _answer1 = true;
                            _answer2 = false;
                            _answer3 = false;
                            _answer4 = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: _answer1
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.check, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            color: _answer1 ? Colors.green : Colors.white,
                          ),
                          height: 24,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text('A: '),
                              Expanded(
                                child: SizedBox(
                                  //width: _screenWidth * 0.7,
                                  child: Text(
                                    _example1,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _answer1 = false;
                            _answer2 = true;
                            _answer3 = false;
                            _answer4 = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: _answer2
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.check, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            color: _answer2 ? Colors.green : Colors.white,
                          ),
                          height: 24,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text('A: '),
                              Expanded(
                                child: SizedBox(
                                  //width: _screenWidth * 0.7,
                                  child: Text(
                                    _example2,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _answer1 = false;
                            _answer2 = false;
                            _answer3 = true;
                            _answer4 = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: _answer3
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.check, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            color: _answer3 ? Colors.green : Colors.white,
                          ),
                          height: 24,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text('A: '),
                              Expanded(
                                child: SizedBox(
                                  //width: _screenWidth * 0.7,
                                  child: Text(
                                    _example3,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _answer1 = false;
                            _answer2 = false;
                            _answer3 = false;
                            _answer4 = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: _answer4
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.check, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            color: _answer4 ? Colors.green : Colors.white,
                          ),
                          height: 24,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text('A: '),
                              Expanded(
                                child: SizedBox(
                                  //width: _screenWidth * 0.7,
                                  child: Text(
                                    _example4,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        throw ArgumentError('Invalid quiz type');
    }
  }
}
