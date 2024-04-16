import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

//그룹 상세 페이지

class GroupInfoScreen extends StatefulWidget {
  final String groupName;
  
  const GroupInfoScreen({
    super.key,
    required this.groupName,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoState();
}


class _GroupInfoState extends State<GroupInfoScreen> {

  //그룹의 모임원 여부
  bool isGroupMember = false;

  List<Widget> _buildTaskList(BuildContext context, int entryCase, String Name) {
    List<Widget> tasks = [];
    for (int i = 0; i < entryCase; i++) {
      tasks.add(_buildTaskEntry(context, i, Name));
      tasks.add(SizedBox(height: 2,));
    }
    return tasks;
  }

  Widget _buildTaskEntry(BuildContext context, int index, String entryName){
    return InkWell(
      onTap: (){
        // 과제가 탭되었을 때 수행할 작업
        print('${entryName} ${index + 1} 탭됨');
      },
      child: Container(
        width: 50.w,
        margin: EdgeInsets.only(bottom: 2), // 각 항목 사이의 간격 설정
        padding: EdgeInsets.all(4), // 내부 패딩 설정
        decoration: BoxDecoration(
          color: Colors.grey[300], // 배경색 설정
          borderRadius: BorderRadius.circular(10), // 모서리 둥글게
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 3.0,),
          child: Text(
            entryName + '${index + 1}',
          ),
        ), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 675),
      builder:(context, child) => Scaffold(
        // backgroundColor: Color(0xffE7FFEB),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Color(0xffE7FFEB),
          title: Text(
            widget.groupName
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Visibility(
                visible: !isGroupMember,
                child: Ink(
                  width: 70.w,
                  height: 30.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Color(0xFFEEF1F4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: InkWell(
                    child: Center(
                      child: Text(
                        '가입하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onTap:(){
                      // 회원 가입 동작 
                      setState(() {
                        isGroupMember = true;  
                      });
                    },
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: 390,
                  height: 295,
                  decoration: ShapeDecoration(
                    color: Color(0xFF0E9913),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: SizedBox(
                            child: Text(
                              '원씽(The One Thing)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                                height: 0.06,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38.h,
                ),
                //과제
                Container(
                  width: 350.w,
                  height: 120.h,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                          BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                          )
                      ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5.0,
                          top: 3.0,
                        ),
                        child: Text(
                          '과제',
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
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          children: _buildTaskList(context, 10, '과제'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38.h,
                ),
                //공지사항
                Container(
                  width: 350.w,
                  height: 120.h,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                          BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                          )
                      ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5.0,
                          top: 3.0,
                        ),
                        child: Text(
                          '공지사항',
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
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          children: _buildTaskList(context, 10, '공지사항'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38.h,
                ),
                //게시판
                Container(
                  width: 350.w,
                  height: 120.h,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                          BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                          )
                      ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5.0,
                          top: 3.0,
                        ),
                        child: Text(
                          '게시판',
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
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          children: _buildTaskList(context, 10, '게시판'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38.h,
                ),
                Container(
                  width: 350.w,
                  height: 120.h,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      shadows: [
                          BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                          )
                      ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}


