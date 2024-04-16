import 'package:flutter/cupertino.dart';
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

final List<String> Thema = ['소설', '에세이', '자기개발서', 'SF', '시집'];
final List<String> Test1 = ['Test1', '캡스톤디자인', '최창연', '정지환', '이현준'];
final List<String> Test2 = ['Test2', '짜장면', '짬뽕'];
final List<String> Test3 = ['Test3', 'White', 'Red', 'Blue', 'Green', 'Pupple', 'Orange', 'Pink', 'Gray'];
final List<String> Test4 = ['Test4', '에어팟', '아이폰', '맥', '맥북'];
final List<String> Test5 = ['Test5', 'Snow', 'Rain', 'Sunny'];

class _GroupState extends State<GroupScreen> {

  ScrollController scrollController = ScrollController();

  //스크롤 위치 출력
  void initState(){
    super.initState();
    scrollController.addListener(() {
      print(scrollController.offset);
    });
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
            '모임'
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 90.h,
                decoration: BoxDecoration(
                  color: Color(0xffE7FFEB),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: List.generate(Thema.length, (int i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // 정사각형 버튼의 모양을 만듦
                                  ),
                                ),
                                onPressed: (){
                                  print(Thema[i] + ' 눌렸습니다.');
                                  final buttonOffset = i * 180.0; // 각 버튼의 높이를 기준으로 스크롤 위치를 계산합니다.                                  
                                  scrollController.animateTo(buttonOffset, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },  
                                child: Text(Thema[i]),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: List.generate(Thema.length, (int i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.5),
                              child: ElevatedButton(
                                onPressed: (){
                                  print(Thema[i] + ' 눌렸습니다.');
                                }, 
                                child: Text(Thema[i]),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      //1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              Thema[0],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(Test1.length, (int i) {
                                  return GroupListItem(groupName: Test1[i]);
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      //2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              Thema[1],
                            ),
                          ),
                          SingleChildScrollView(  
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(Test2.length, (int i) {
                                  return GroupListItem(groupName: Test2[i]);
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      //3
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              Thema[2],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(Test3.length, (int i) {
                                  return GroupListItem(groupName: Test3[i]);
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      //4
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              Thema[3],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(Test4.length, (int i) {
                                  return GroupListItem(groupName: Test4[i]);
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      //5
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              Thema[4],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(Test5.length, (int i) {
                                  return GroupListItem(groupName: Test5[i]);
                                }
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
      ),
    );
  }
}


