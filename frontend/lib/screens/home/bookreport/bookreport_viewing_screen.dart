import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BookReportViewingScreen extends StatefulWidget {
  final dynamic contentData;

  const BookReportViewingScreen({super.key, required this.contentData});

  @override
  State<BookReportViewingScreen> createState() => _BookReportViewingState();
}

class _BookReportViewingState extends State<BookReportViewingScreen> {
  final TextEditingController _answerController = TextEditingController();
  // List<dynamic> _contentData = [];
  final dynamic _startDate = DateTime.now();
  final dynamic _endDate = DateTime.now();
  //bool _isPublic = false;
  String _template = '';
  String _writer = '';
  String _title = '';
  String _booktitle = '';
  String _body = '';
  String _author = "작가";
  String _publisher = "출판사";
  String _category = '';
  String _answer = '';
  bool _oxanswer = false;
  final List<dynamic> _exampleList = [null, null, null, null];
  final List<dynamic> _multipleanswer = [false, false, false, false];
  var token;

  void initializeClubContentData(dynamic content) {
    print(content);
    setState(() {
      _template = contentTypeCheck(content['type']);
      _writer = content['writer'];
      _author = content['book']['author'];
      _publisher = content['book']['publisher'];
      print(_template);
      if (_template == "독후감" || _template == "한줄평" || _template == "인용구") {
        _body = content['body'];
        _title = content['title'];
        _booktitle = content['book']['title'];
      } else {
        _category = quizCategory(content['type']);
        _answer = content['answer'];
        _body = content['description'];
        _title = content['description'];
        for (int i = 0; i < 4; i++) {
          _exampleList[i] = content['example${i + 1}'];
        }
      }
    });
  }

  String contentTypeCheck(String template) {
    switch (template) {
      case "Review":
        return "독후감";
      case "ShortReview":
        return "한줄평";
      case "Quotation":
        return "인용구";
      default:
        return "퀴즈";
    }
  }

  String quizCategory(String template) {
    switch (template) {
      case "MultipleChoice":
        return "객관식";
      case "ShortAnswer":
        return "단답형";
      case "OX":
        return "O/X";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _initUserState();
    initializeClubContentData(widget.contentData);
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
                  Text(_booktitle),
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
              child: Row(
                children: [
                  Expanded(
                child: _buildTemplateUI(_template),
              ),
                ],
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
                  child: Text(
                    _category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(
                child: _buildQuizUI(_category),
              ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    switch (_category) {
                      case "단답형":
                        if (_answerController.text == _answer) {
                          // 맞음
                          _showRightDialog();
                        } else {
                          // 틀림
                          _showWrongDialog();
                        }
                        break;
                      case "O/X":
                        if (_answer == 'O') {
                          if (_oxanswer) {
                            // 맞음
                            _showRightDialog();
                          } else {
                            // 틀림
                            _showWrongDialog();
                          }
                        } else {
                          if (!_oxanswer) {
                            //맞음
                            _showRightDialog();
                          } else {
                            //틀림
                            _showWrongDialog();
                          }
                        }
                        break;
                      case "객관식":
                        int check = int.parse(_answer) - 1;
                        if (_multipleanswer[check]) {
                          // 맞음
                          _showRightDialog();
                        } else {
                          // 틀림
                          _showWrongDialog();
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  child: const Text('정답확인'),
                ),
              ],
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                width: 350.w,
                height: 190.h,
                child: Stack(
                  children: [
                    Container(
                      width: 350,
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(height: 40.h),
                          const Text('Q: '),
                          SizedBox(width: 10.w),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                width: 350.w,
                height: 190.h,
                child: Stack(
                  children: [
                    Container(
                      width: 350,
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(height: 40.h),
                          const Text('Q: '),
                          SizedBox(width: 10.h),
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
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                width: 350.w,
                height: 190.h,
                child: Stack(
                  children: [
                    Container(
                      width: 350,
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(height: 40.h),
                          const Text('Q: '),
                          SizedBox(width: 10.w),
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
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  for (int i = 0; i < _exampleList.length; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  for (int j = 0; j < 4; j++) {
                                    if (i == j) {
                                      _multipleanswer[j] = true;
                                    } else {
                                      _multipleanswer[j] = false;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                child: _multipleanswer[i]
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const Icon(Icons.check,
                                        color: Colors.grey),
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
                                  color: _multipleanswer[i]
                                      ? Colors.green
                                      : Colors.white,
                                ),
                                height: 24.h,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10.w),
                                    const Text('A: '),
                                    Expanded(
                                      child: SizedBox(
                                        //width: _screenWidth * 0.7,
                                        child: Text(
                                          _exampleList[i],
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

  void _showRightDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('정답'),
          content: Text('정답을 맞추셨습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void _showWrongDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('오답'),
          content: Text('정답을 틀리셨습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }
}
