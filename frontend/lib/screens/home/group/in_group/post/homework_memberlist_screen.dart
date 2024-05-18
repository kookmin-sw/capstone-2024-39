import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

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
        _HwList = hw['contentList'];
        _hw = hw;
        break;
      }
    }
    setState(() {
      HW = _hw;
      HwList = _HwList;
      isbn = _club['book']['isbn'];
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
    print(widget.post);
    initUserInfo();
    updateHwList();
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
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
                  }).then((value) async {
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.17,
                      ),
                    ),
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
