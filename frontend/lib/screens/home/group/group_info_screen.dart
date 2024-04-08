import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfoScreen> {
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
            '모임 상세 페이지'
          ),
          centerTitle: true,
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
                SizedBox(
                  height: 38.h,
                ),
                Container(
                  width: 350.w,
                  height: 90.h,
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


