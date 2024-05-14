import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

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
  // var userInfo;
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
                color: _selectType[i] ? Color(0xFF0E9913) : Colors.black,
                fontSize: 16,
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
    _review = await bookcontentLoad(token, widget.data['isbn'], 'Review');
    _quotation = await bookcontentLoad(token, widget.data['isbn'], 'Quotation');
    _quotation =
        await bookcontentLoad(token, widget.data['isbn'], 'ShortReview');
    _quiz = await bookQuizLoad(token, widget.data['isbn']);

    setState(() {
      review = _review;
      shortreview = _shortreview;
      quotation = _quotation;
      quiz = _quiz;
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

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
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
          title: Text(
            widget.data['title'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
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
              child: Container(
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
                          child: Container(
                            child: Text(
                              widget.data['description'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
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
                          // context.push('/homework_list');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 5.0,
                                top: 3.0,
                              ),
                              child: Text(
                                '퀴즈',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Noto Sans KR',
                                  fontWeight: FontWeight.w700,
                                ),
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
                      height: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          children: postType(context, ['독후감', '한줄평', '인용구']),
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
                              // context.push('/homework_list');
                              if (_selectType[0]) {
                              } else if (_selectType[1]) {
                              } else if (_selectType[2]) {}
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (_selectType[0])
                                    ? Expanded(
                                        child: ListView(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50.0),
                                          children:
                                              _buildTaskList(context, '독후감'),
                                        ),
                                      )
                                    : (_selectType[1])
                                        ? Expanded(
                                            child: ListView(
                                              shrinkWrap: true,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50.0),
                                              children: _buildTaskList(
                                                  context, '한줄평'),
                                            ),
                                          )
                                        : Expanded(
                                            child: ListView(
                                              shrinkWrap: true,
                                              padding:
                                                  const EdgeInsets.symmetric(
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
  List<Widget> _buildTaskList(BuildContext context, String type, String isbn) {
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
        if (clubHwList == null) {
          break;
        }
        temp = clubHwList;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 3) {
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
        if (clubHwList == null) {
          break;
        }
        temp = clubHwList;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 3) {
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
        if (clubHwList == null) {
          break;
        }
        temp = clubHwList;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 3) {
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
        //퀴즈 탭 됐을 때
        if (isQuiz) {
          if (_isGroupMember) {
            context.push('/post', extra: {
              'postId': post['id'],
              'clubId': post['clubId'],
            }).then((value) async {
              updateBookcontent();
            });
          }
        }
        //과제가 탭 됐을 때
        else {
          if (_isGroupMember) {
            context.push('/homeworkmember_make', extra: {
              'post': post,
              'clubId': widget.clubId,
            }).then((value) async {});
          }
        }
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
            (isQuiz) ? post['title'] : post['name'],
          ),
        ),
      ),
    );
  }
}
