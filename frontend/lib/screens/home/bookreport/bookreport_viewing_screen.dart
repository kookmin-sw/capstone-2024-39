import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend/env.dart';

class BookReportViewingScreen extends StatefulWidget {
  final dynamic contentData;

  const BookReportViewingScreen({super.key, required this.contentData});

  @override
  State<BookReportViewingScreen> createState() => _BookReportViewingState();
}

class _BookReportViewingState extends State<BookReportViewingScreen> {
  final TextEditingController _answerController = TextEditingController();
  // List<dynamic> _contentData = [];
  dynamic _startDate = DateTime.now();
  dynamic _endDate = DateTime.now();
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
    setState(() {
      _template = contentTypeCheck(content['type']);
      _writer = content['writer'];
      _author = content['book']['author'];
      _publisher = content['book']['publisher'];
      _booktitle = content['book']['title'];
      _startDate = _formatDate(content['startDate']);
      _endDate = _formatDate(content['endDate']);
      if (_template == "독후감" || _template == "한줄평" || _template == "인용구") {
        _body = content['body'];
        _title = content['title'];
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
        titleTextStyle: textStyle(22, Colors.white, true),
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
            (_template != '퀴즈')
                ? Column(
                    children: [
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              '제목 : ',
                              style: textStyle(15, null, false),
                            ),
                            Text(
                              _title,
                              style: textStyle(15, null, false),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFFA9AFB7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _booktitle,
                      style: textStyle(15, null, true),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    '$_author | $_publisher',
                    style: textStyle(13, null, false),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    '독서기간 :',
                    style: textStyle(13, null, false),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Text(
                    _startDate,
                    style: textStyle(13, null, false),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    '~',
                    style: textStyle(13, null, false),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    _endDate,
                    style: textStyle(13, null, false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
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
            SizedBox(height: 15.h),
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
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateUI(String template) {
    switch (template) {
      case "독후감":
        return Text(
          _body,
          style: textStyle(14, null, false),
        );
      case "한줄평":
        return Text(
          _body,
          style: textStyle(14, null, false),
        );
      case "인용구":
        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  _body,
                  style: textStyle(14, null, false),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '카테고리: ',
                  style: textStyle(15, null, false),
                ),
                const SizedBox(width: 3),
                SizedBox(
                  child: Text(
                    _category,
                    style: textStyle(14, null, false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
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
                                style: textStyle(14, null, false),
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
                        style: textStyle(14, null, false),
                        controller: _answerController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '답을 입력하세요',
                            hintStyle: textStyle(14, Colors.grey, false)),
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
                                style: textStyle(14, null, false),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                style: textStyle(14, null, false),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10.w),
                                    const Text('A: '),
                                    Expanded(
                                      child: SizedBox(
                                        //width: _screenWidth * 0.7,
                                        child: Text(
                                          _exampleList[i],
                                          style: textStyle(12, null, false),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
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

String _formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}
