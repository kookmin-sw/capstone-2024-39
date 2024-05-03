import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/home/group/in_group/group_info_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'package:frontend/provider/grouplist_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupState();
}

final List<String> Thema = ['역사', '경제', '종교', '사회', '시집'];
List<List<dynamic>> _GroupList = [[],[],[],[],[]];

class _GroupState extends State<GroupScreen> {
  ScrollController _scrollController = ScrollController();

  // @override
  // Future<void> setState(VoidCallback fn) async {
  //   // TODO: implement setState
  //   super.setState;
  //   _makeGroupList();
  // }

  void _makeGroupList() async {
    for (int i = 0; i < Thema.length; i++) {
      _GroupList[i] = await groupSerachforTopic(Thema[i]);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _makeGroupList();
    _scrollController.addListener(() {});
  }

  //테마별로 리스트 버튼 구현 + 스크롤 이동 구현
  Widget _ThemaList(
    BuildContext context,
    List<String> Thema,
  ) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: List.generate(Thema.length, (int i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(
                          // borderRadius: BorderRadius.circular(10), // 정사각형 버튼의 모양을 만듦
                          ),
                      elevation: 5,
                      shadowColor: Colors.grey,
                    ),
                    onPressed: () {
                      // print(group[i].length);
                      print(Thema[i] + ' 눌렸습니다.');
                      final buttonOffset =
                          i * 180.0; // 각 버튼의 높이를 기준으로 스크롤 위치를 계산합니다.
                      _scrollController.animateTo(buttonOffset,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Text('${i + 1}'),
                  ),
                  Text(Thema[i]),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget groupList(int index) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                Thema[index],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_GroupList[index].length, (int i) {
                  return GroupListItem(
                    groupName: _GroupList[index][i]['name'], 
                    groupCnt: _GroupList[index][i]['maximum'],
                    publicState: _GroupList[index][i]['publicstatus'],
                    topic: _GroupList[index][i]['topic'],
                  );
                }),
              ),
            ),
          ],
        ),
        SizedBox(
          height: (index != 4)? 10.h : 500.h,
        ),
      ],
    );
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
            '모임',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/group_make');
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 120.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E9913),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ThemaList(context, Thema),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      //0
                      groupList(0),
                      //1
                      groupList(1),
                      //2
                      groupList(2),
                      //3
                      groupList(3),
                      //4
                      groupList(4),
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
