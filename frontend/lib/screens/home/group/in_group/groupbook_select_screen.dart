import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart';
import 'package:frontend/screens/home/search/search_screen_util.dart'
    as SearchUtil;
import 'package:frontend/http.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:go_router/go_router.dart';

//그룹 대표책 설정 페이지
List<dynamic> BookData = [];

class GroupBookSelectScreen extends StatefulWidget {
  final String title;
  final int clubId;

  const GroupBookSelectScreen({
    super.key,
    required this.title,
    required this.clubId,
  });

  @override
  State<GroupBookSelectScreen> createState() => _GroupBookSelectState();
}

class _GroupBookSelectState extends State<GroupBookSelectScreen> {
  void _SearchData(String text) async {
    BookData = await SearchBook(text);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _SearchData(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFF0E9913),
          title: const Text(
            '대표책 검색',
          ),
          titleTextStyle: textStyle(22, null, true),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      if (BookData.isNotEmpty)
                        for (int i = 0; i < BookData.length; i++)
                          SearchUtil.SearchListItem(
                            data: BookData[i],
                            type: "select",
                            clubId: widget.clubId,
                          ),
                      if (BookData.isEmpty)
                        Text(
                          '검색된 책이 없습니다.',
                          style: textStyle(14, null, true),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle textStyle(int fontsize, var color, bool isStroke) {
  return TextStyle(
    fontSize: fontsize.sp,
    fontWeight: (isStroke) ? FontWeight.bold : FontWeight.normal,
    fontFamily: 'Noto Sans KR',
    color: color,
  );
}
