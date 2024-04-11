import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/home/group/group_info_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart';
import 'package:go_router/go_router.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupState();
}

final List<String> Test = ['Test1', '캡스톤디자인', '최창연', '정지환', '이현준'];

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
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(Test.length, (int i) {
                        return GroupListItem(groupName: Test[i]);
                      }
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(Test.length, (int i) {
                        return GroupListItem(groupName: Test[i]);
                      }
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(Test.length, (int i) {
                        return GroupListItem(groupName: Test[i]);
                      }
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


