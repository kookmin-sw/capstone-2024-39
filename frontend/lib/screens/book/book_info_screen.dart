import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:frontend/env.dart';

class BookInfoScreen extends StatefulWidget {
  final Map<String, dynamic> data; //책 정보

  const BookInfoScreen({
    super.key,
    required this.data,
  });

  @override
  State<BookInfoScreen> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfoScreen> {
  var secureStorage;
  var id, token;
  var review, shortreview, quotation, quiz;
  bool _isLoading = true;
  List<bool> _selectType = [true, false, false];

  List<Widget> postType(BuildContext context, List<String> type) {
    List<Widget> temp = [];
    for (int i = 0; i < _selectType.length; i++) {
      temp.add(Padding(
        padding: EdgeInsets.only(
          left: (i == 0) ? 24.0 : 0,
          right: 5.0,
        ),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              setState(() {
                for (int j = 0; j < _selectType.length; j++) {
                  if (i == j) {
                    _selectType[j] = true;
                  } else {
                    _selectType[j] = false;
                  }
                }
              });
            },
            child: Text(
              type[i],
              style: TextStyle(
                color: _selectType[i] ? const Color(0xFF0E9913) : Colors.black,
                fontSize: 16.sp,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ));
    }
    return temp;
  }

  Future<void> updateBookcontent() async {
    var _review, _shortreview, _quotation, _quiz;
    _review = await bookcontentLoad(widget.data['isbn'], 'Review');
    _quotation = await bookcontentLoad(widget.data['isbn'], 'Quotation');
    _shortreview = await bookcontentLoad(widget.data['isbn'], 'ShortReview');
    _quiz = await bookQuizLoad(widget.data['isbn']);

    setState(() {
      review = _review;
      shortreview = _shortreview;
      quotation = _quotation;
      quiz = _quiz;
      // print(review);
      // print(shortreview);
      // print(quotation);
      // print(quiz);
    });
  }

  Future<void> _initUserState() async {
    try {
      var _id = await secureStorage.readData('id');
      var _token = await secureStorage.readData('token');
      // var _userInfo = await getUserInfo(id, token);
      setState(() {
        // userInfo = _userInfo;
        id = _id;
        token = _token;
      });
    } catch (e) {
      setState(() {
        // userInfo = null;
        id = null;
        token = null;
      });
    }
  }

  Future<void> _loadData(int term) async {
    Timer(Duration(milliseconds: term), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    _loadData(500);
    _initUserState();
    updateBookcontent();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFF0E9913),
          title: Text("책 정보", style: textStyle(22, Colors.white, true)),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(), // 로딩 애니매이션
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0E9913),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setHeight(105),
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(widget.data['image']),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 20.w,
                              bottom: 20.h,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data['title'],
                                    style: textStyle(20, Colors.white, true),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "${(widget.data['author'] == '') ? '저자 미상' : widget.data['author']} | ${widget.data['publisher']}",
                                    style: textStyle(14, Colors.white, true),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    widget.data['description'],
                                    style: textStyle(13, Colors.white, false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Ink(
                            width: 350.w,
                            height: 120.h,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                context.push('/book_content', extra: {
                                  "posts": quiz,
                                  "type": "Quiz",
                                  "isbn": widget.data['isbn'],
                                }).then((value) async {
                                  updateBookcontent();
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      top: 3.0,
                                    ),
                                    child: Text(
                                      '퀴즈',
                                      style: textStyle(16, null, true),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0),
                                      children: _buildTaskList(context, '퀴즈'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Column(
                            children: [
                              Row(
                                children:
                                    postType(context, ['독후감', '한줄평', '인용구']),
                              ),
                              Ink(
                                width: 350.w,
                                height: 120.h,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    var post, type;
                                    if (_selectType[0]) {
                                      post = review;
                                      type = "Review";
                                    } else if (_selectType[1]) {
                                      post = shortreview;
                                      type = "ShortReview";
                                    } else if (_selectType[2]) {
                                      post = quotation;
                                      type = "Quotation";
                                    }
                                    context.push('/book_content', extra: {
                                      "posts": post,
                                      "type": type,
                                      "isbn": widget.data['isbn'],
                                    }).then((value) async {
                                      updateBookcontent();
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (_selectType[0])
                                          ? Expanded(
                                              child: ListView(
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50.0),
                                                children: _buildTaskList(
                                                    context, '독후감'),
                                              ),
                                            )
                                          : (_selectType[1])
                                              ? Expanded(
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 50.0),
                                                    children: _buildTaskList(
                                                        context, '한줄평'),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 50.0),
                                                    children: _buildTaskList(
                                                        context, '인용구'),
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
                  ),
                ],
              ),
      ),
    );
  }

  //각 게시판의 글들을 리스트로 형성
  List<Widget> _buildTaskList(BuildContext context, String type) {
    List<Widget> tasks = [];
    List<dynamic> temp;
    int cnt = 0;
    switch (type) {
      case '퀴즈':
        if (quiz == null) {
          break;
        }
        temp = quiz;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 4) {
            break;
          }
          cnt++;
          tasks.add(_buildTaskEntry(context, post, true));
          tasks.add(Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
          ));
        }
        break;
      case '독후감':
        if (review == null) {
          break;
        }
        temp = review;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 4) {
            break;
          }
          cnt++;
          tasks.add(_buildTaskEntry(context, post, false));
          tasks.add(Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
          ));
        }
        break;
      case '한줄평':
        if (shortreview == null) {
          break;
        }
        temp = shortreview;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 4) {
            break;
          }
          cnt++;
          tasks.add(_buildTaskEntry(context, post, false));
          tasks.add(Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
          ));
        }
        break;
      case '인용구':
        if (quotation == null) {
          break;
        }
        temp = quotation;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 4) {
            break;
          }
          cnt++;
          tasks.add(_buildTaskEntry(context, post, false));
          tasks.add(Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
          ));
        }
        break;

      default:
        break;
    }

    return tasks;
  }

  //각 게시판의 최신글
  Widget _buildTaskEntry(BuildContext context, var post, bool isQuiz) {
    return InkWell(
      onTap: () {
        // 퀴즈나 다른 컨텐츠 모두 눌러도 가능하도록
        context.push(
          '/bookreport_viewing',
          extra: post,
        );
      },
      child: Container(
        width: 50.w,
        margin: const EdgeInsets.only(bottom: 2), // 각 항목 사이의 간격 설정
        padding: const EdgeInsets.all(4), // 내부 패딩 설정
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 3.0,
          ),
          child: Text(
            isQuiz ? post['description'] : post['title'],
            style: textStyle(14, null, false),
          ),
        ),
      ),
    );
  }
}
