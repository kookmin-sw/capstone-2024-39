import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
      _startDate = formatDate(content['startDate']);
      _endDate = formatDate(content['endDate']);
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
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
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
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  _body,
                  style: textStyle(14, null, false),
                  textAlign: TextAlign.center,
                  maxLines: 10,
                ),
              ),
              Positioned(
                left: -5.w,
                top: 0.w,
                child: const Icon(Icons.format_quote),
              ),
              Positioned(
                right: -5.w,
                bottom: 0.w,
                child: const Icon(Icons.format_quote),
              ),
            ],
          ),
        );
      case "퀴즈":
        return Column(
          children: [
            Row(
              children: [
                Text(
                  '카테고리: ',
                  style: textStyle(15, null, false),
                ),
                SizedBox(width: 3.w),
                SizedBox(
                  width: 121.w,
                  height: 22.h,
                  child: Text(
                    _category,
                    style: textStyle(14, null, false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuizUI(_category),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    switch (_category) {
                      case "단답형":
                        if (_answerController.text == _answer) {
                          _showRightDialog();
                        } else {
                          _showWrongDialog();
                        }
                        break;
                      case "O/X":
                        if ((_answer == 'O' && _oxanswer) ||
                            (_answer == 'X' && !_oxanswer)) {
                          _showRightDialog();
                        } else {
                          _showWrongDialog();
                        }
                        break;
                      case "객관식":
                        int check = int.parse(_answer) - 1;
                        if (_multipleanswer[check]) {
                          _showRightDialog();
                        } else {
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
                      width: 350.w,
                      height: 190.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(width: 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          SizedBox(height: 40.h),
                          const Text('Q: '),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              _body,
                              style: TextStyle(fontSize: 14.sp),
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  const Text('A: '),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 14.sp),
                      controller: _answerController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '답을 입력하세요',
                        hintStyle: TextStyle(fontSize: 14.sp),
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
                      width: 350.w,
                      height: 220.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(width: 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          SizedBox(height: 40.h),
                          const Text('Q: '),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              _body,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      side: BorderSide(width: 0.5.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      minimumSize: Size(140.w, 140.h),
                    ),
                    child: Text('O', style: TextStyle(fontSize: 24.sp)),
                  ),
                  SizedBox(width: 30.w),
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
                      side: BorderSide(width: 0.5.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      minimumSize: Size(140.w, 140.h),
                    ),
                    child: Text('X', style: TextStyle(fontSize: 24.sp)),
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
                      width: 350.w,
                      height: 220.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(width: 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          SizedBox(height: 40.h),
                          const Text('Q: '),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              _body,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
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
                                    _multipleanswer[j] = i == j;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(0.w),
                                child: Icon(
                                  Icons.check,
                                  color: _multipleanswer[i]
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5.w,
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
                                    Text('A: ',
                                        style: TextStyle(fontSize: 14.sp)),
                                    Expanded(
                                      child: Text(
                                        _exampleList[i] ?? '',
                                        style: TextStyle(fontSize: 14.sp),
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
          title: const Text('정답'),
          content: const Text('정답을 맞추셨습니다.'),
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
          title: const Text('오답'),
          content: const Text('정답을 틀리셨습니다.'),
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

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

TextStyle textStyle(int fontsize, var color, bool isStroke) {
  return TextStyle(
    fontSize: fontsize.sp,
    fontWeight: (isStroke) ? FontWeight.bold : FontWeight.normal,
    fontFamily: 'Noto Sans KR',
    color: color,
  );
}
