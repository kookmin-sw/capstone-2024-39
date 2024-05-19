import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//과제 목록 페이지

class HomeworkListScreen extends StatefulWidget {
  final String managerId;
  final int clubId;
  final dynamic bookInfo;

  const HomeworkListScreen({
    super.key,
    required this.managerId,
    required this.clubId,
    required this.bookInfo,
  });

  @override
  State<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends State<HomeworkListScreen> {
  List<dynamic> posts = [];
  bool isBook = true;
  var secureStorage;
  var id;
  var token;

  Future<void> initUserInfo() async {
    var _id = await secureStorage.readData("id");
    var _token = await secureStorage.readData("token");
    setState(() {
      id = _id;
      token = _token;
    });
  }

  Future<void> updatePostList() async {
    var _posts = await getAssign(widget.clubId);
    if (_posts.runtimeType == Map<String, dynamic>) {
      _posts = [];
    }
    setState(() {
      posts = _posts;
    });
  }

  void checkBook(dynamic Book) {
    if (Book == null) {
      setState(() {
        isBook = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    checkBook(widget.bookInfo);
    initUserInfo();
    updatePostList();
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
            '과제',
            style: textStyle(22, Colors.white, true),
          ),
          centerTitle: true,
        ),
        floatingActionButton: (id == widget.managerId && isBook)
            ? FloatingActionButton(
                onPressed: () {
                  context
                      .push(
                    '/homework_make',
                    extra: widget.clubId,
                  )
                      .then((result) async {
                    updatePostList();
                  });
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(posts),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPostListView(List<dynamic> posts) {
    List<Widget> items = [];

    for (Map<String, dynamic> post in posts) {
      items.add(
        Column(
          children: [
            SizedBox(
              height: 58.h,
              width: double.infinity,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    context.push('/homeworkmember_make', extra: {
                      'post': post,
                      'clubId': widget.clubId,
                    }).then((value) async {
                      updatePostList();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w, top: 10.w),
                                child: Text(
                                  post['name'],
                                  style: textStyle(20, null, false),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.w, top: 10.w),
                                child: Text(
                                  HwType(post['type']),
                                  style: textStyle(14, null, false),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  '과제기한:',
                                  style: textStyle(12, Colors.grey, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  post['startDate'],
                                  style: textStyle(12, Colors.grey, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  '~',
                                  style: textStyle(12, Colors.grey, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  post['endDate'],
                                  style: textStyle(12, Colors.grey, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  (limitDate(post['endDate']))
                                      ? "제출가능"
                                      : "제출마감",
                                  style: (limitDate(post['endDate']))
                                      ? textStyle(12, Colors.grey, false)
                                      : textStyle(12, Colors.red, true),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 30.w,
                          height: 47.h,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE4E7EA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  '${post['contentList'].length}',
                                  style: textStyle(13, null, false),
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                '과제',
                                style: textStyle(13, Colors.grey, false),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return items;
  }
}

String HwType(String type) {
  switch (type) {
    case 'Review':
      return '독후감';
    case 'ShortReview':
      return '한줄평';
    case 'Quotation':
      return '인용구';
    case 'Quiz':
      return '퀴즈';
    default:
      return '';
  }
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('yyyy.MM.dd. HH:mm').format(dateTime);

  return formattedDate;
}

bool limitDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateTime nowTime = DateTime.now();

  return dateTime.isAfter(nowTime);
}

TextStyle textStyle(int fontsize, var color, bool isStroke) {
  return TextStyle(
    fontSize: fontsize.sp,
    fontWeight: (isStroke) ? FontWeight.bold : FontWeight.normal,
    fontFamily: 'Noto Sans KR',
    color: color,
  );
}
