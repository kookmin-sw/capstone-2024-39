import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/home/group/in_group/group_info_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';

// final List<String> Thema = ['역사', '경제', '종교', '사회', '시집'];
final List<String> Thema = ['예술과 문학', '금융/경제/투자', '과학과 철학', '자기개발', '역사', '취미'];
//수정 전 - 역사, 경제, 종교, 사회, 시집
//수정 - 예술과 문학, 금융/경제/투자, 과학과 철학, 자기개발, 역사, 취미
//삭제 - 시집
List<List<dynamic>> _GroupList = [[], [], [], [], [], []];

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupState();
}

class _GroupState extends State<GroupScreen> {
  ScrollController _scrollController = ScrollController();

  Future<void> _makeGroupList() async {
    _GroupList = await groupSerachforTopic(Thema);
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
      child: Column(
        children: List.generate((Thema.length / 3).ceil(), (int i) {
          int startIndex = i * 3;
          int endIndex = (i + 1) * 3;
          if (endIndex > Thema.length) endIndex = Thema.length;

          List<Widget> rowButtons = [];
          for (int j = startIndex; j < endIndex; j++) {
            rowButtons.add(
              SizedBox(
                height: ScreenUtil().setHeight(100),
                width: ScreenUtil().setWidth(100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        elevation: 5,
                        shadowColor: Colors.grey,
                      ),
                      onPressed: () {
                        print('${Thema[j]} 눌렸습니다.');
                        final buttonOffset = j * 180.0;
                        _scrollController.animateTo(buttonOffset,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Text('${j + 1}'),
                    ),
                    Text(Thema[j]),
                  ],
                ),
              ),
            );
          }
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowButtons,
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
                    id: _GroupList[index][i]['id'],
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
          height: (index != 5)
              ? ScreenUtil().setHeight(10)
              : ScreenUtil().setHeight(500),
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
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(390),
                decoration: const BoxDecoration(
                  color: Color(0xFF0E9913),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: SizedBox(
                  width: ScreenUtil().setWidth(390),
                  child: _ThemaList(context, Thema),
                ),
                
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _makeGroupList();
                  },
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
                        //5
                        groupList(5),
                      ],
                    ),
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
