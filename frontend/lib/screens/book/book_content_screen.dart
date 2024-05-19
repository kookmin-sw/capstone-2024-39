import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//책의 컨텐츠 목록

class BookContentScreen extends StatefulWidget {
  final dynamic posts;
  final String type;
  final String isbn;

  const BookContentScreen({
    super.key,
    required this.posts,
    required this.type,
    required this.isbn,
  });

  @override
  State<BookContentScreen> createState() => _BookContentState();
}

class _BookContentState extends State<BookContentScreen> {
  List<dynamic> posts = [];
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
    var _posts;
    if (widget.type == "Quiz") {
      _posts = await bookQuizLoad(widget.isbn);
    } else {
      _posts = await bookcontentLoad(widget.isbn, widget.type);
    }
    if (_posts.runtimeType == Map<String, dynamic>) {
      _posts = [];
    }
    setState(() {
      posts = _posts;
    });
  }

  int typeCheck(String types) {
    switch (types) {
      case "Review":
        return 996;
      case "ShortReview":
        return 997;
      case "Quotation":
        return 998;
      case "Quiz":
        return 999;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    initUserInfo();
    setState(() {
      posts = widget.posts;
      print(posts);
      print(widget.type);
    });
    // updatePostList();
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
            contentType(widget.type),
            style: textStyle(22, Colors.white, true),
          ),
          centerTitle: true,
        ),
        floatingActionButton: (id != null && token != null)
            ? FloatingActionButton(
                onPressed: () {
                  context.push(
                    '/bookreport_writing',
                    extra: {
                      "index": typeCheck(widget.type),
                      "clubId": null,
                      "asId": null,
                      "isbn": widget.isbn,
                      "dateInfo": null,
                    },
                  ).then((result) async {
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
                    context.push(
                      '/bookreport_viewing',
                      extra: post,
                    );
                  },
                  // child: Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     (widget.type == "Quiz")
                  //         ? post['description']
                  //         : post['title'],
                  //     style: textStyle(20, null, true),
                  //   ),
                  // ),
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
                                  (widget.type == "Quiz")
                                      ? post['description']
                                      : post['title'],
                                  style: textStyle(18, null, false),
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
                                  "작성자 ${post['writer']}",
                                  style: textStyle(12, null, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  (widget.type != 'Quiz')
                                      ? contentType(post['type'])
                                      : quizType(post['type']),
                                  style: textStyle(13, null, false),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
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

String contentType(String type) {
  switch (type) {
    case 'Review':
      return '독후감';
    case 'ShortReview':
      return '한줄평';
    case 'Quotation':
      return '인용구';
    default:
      return '퀴즈';
  }
}

String quizType(String quiz) {
  switch (quiz) {
    case 'ShortAnswer':
      return '단답형';
    case 'MultipleChoice':
      return '객관식';
    case 'OX':
      return 'O/X';
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
