import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupState();
}

class _GroupState extends State<GroupScreen> {
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
            '모임'
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Ink(
                  width: 150.w,
                  height: 90.h,
                  child: InkWell(
                    child: Text(
                      'Test_Group1',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      context.push('/group_info');
                    },
                    borderRadius: BorderRadius.circular(15),
                  ),
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
                ),
                SizedBox(
                  width: 10.w,
                ),
                Ink(
                  width: 150.w,
                  height: 90.h,
                  child: InkWell(
                    child: Text(
                      'Test_Group2',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      
                    },
                    borderRadius: BorderRadius.circular(15),
                  ),
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
                ),
                SizedBox(
                  width: 10.w,
                ),
                Ink(
                  width: 150.w,
                  height: 90.h,
                  child: InkWell(
                    child: Text(
                      'Test_Group3',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      
                    },
                    borderRadius: BorderRadius.circular(15),
                  ),
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
                ),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


