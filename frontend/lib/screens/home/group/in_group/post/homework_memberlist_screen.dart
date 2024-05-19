import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//멤버들 과제 리스트

class HomeworkMemberlistScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final int clubId;

  const HomeworkMemberlistScreen({
    super.key,
    required this.post,
    required this.clubId,
  });

  @override
  State<HomeworkMemberlistScreen> createState() => _HomeworkMemberistState();
}

class _HomeworkMemberistState extends State<HomeworkMemberlistScreen> {
  List<dynamic> HwList = [];
  bool LimitCheck = true;
  dynamic hwType;
  var secureStorage;
  var id;
  var token;
  var HW;
  var isbn;

  Future<void> initUserInfo() async {
    var _id = await secureStorage.readData("id");
    var _token = await secureStorage.readData("token");
    setState(() {
      id = _id;
      token = _token;
    });
  }

  Future<void> updateHwList() async {
    var _posts = await getAssign(widget.clubId);
    var _club = await groupSerachforId(widget.clubId);
    var _HwList, _hw;
    for (Map<String, dynamic> hw in _posts) {
      if (hw['id'] == widget.post['id']) {
        if (hw['type'] == 'Quiz') {
          _HwList = hw['quizList'];
        } else {
          _HwList = hw['contentList'];
        }
        hwType = hw['type'];
        _hw = hw;
        break;
      }
    }
    setState(() {
      HW = _hw;
      HwList = _HwList;
      isbn = _club['book']['isbn'];
      // print(HwList);
    });
  }

  int typeCheck(Map<String, dynamic> hw) {
    switch (hw['type']) {
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

  void dateCheck(String date) {
    DateTime limitDate = DateTime.parse(date);
    DateTime now = DateTime.now();

    if (limitDate.isBefore(now)) {
      setState(() {
        LimitCheck = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    dateCheck(widget.post['endDate']);
    initUserInfo();
    updateHwList();
    // print(HwList);
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
            widget.post['name'],
            style: textStyle(22, Colors.white, true),
          ),
          centerTitle: true,
        ),
        floatingActionButton: (LimitCheck)
            ? FloatingActionButton(
                onPressed: () {
                  //퀴즈 999, 인용구 998, 한줄평 997, 독후감 996
                  context.push("/bookreport_writing", extra: {
                    "index": typeCheck(HW),
                    "clubId": widget.clubId,
                    "asId": HW['id'],
                    "isbn": isbn,
                    "dateInfo": {
                      "startDate": widget.post['startDate'],
                      "endDate": widget.post['endDate']
                    }
                  }).then((value) {
                    updateHwList();
                  });
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: _buildHWListView(HwList),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHWListView(List<dynamic> posts) {
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
                    // print(post);
                    context.push(
                      '/bookreport_viewing',
                      extra: post,
                    );
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
                                  (hwType == 'Quiz')
                                      ? post['description']
                                      : post['title'],
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
                                  "작성자 ${post['writer']}",
                                  style: textStyle(12, Colors.grey, false),
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
    default:
      return '퀴즈';
  }
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('yyyy.MM.dd. HH:mm').format(dateTime);
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
