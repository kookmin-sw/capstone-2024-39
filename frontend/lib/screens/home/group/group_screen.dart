import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/home/group/in_group/group_info_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

final List<String> realThema = [
  '예술과 문학',
  '금융/경제/투자',
  '과학과 철학',
  '자기계발',
  '역사',
  '취미'
];
final List<String> Thema = [
  '예술과 문학',
  '금융/경제/투자',
  '과학과 철학',
  '자기계발',
  '역사',
  '취미',
  '내 모임',
  '추천',
];
final List<IconData> ThemaIcon = [
  Icons.palette_outlined,
  Icons.attach_money,
  Icons.science_outlined,
  Icons.self_improvement,
  Icons.history_edu,
  Icons.hail_outlined,
  // Icons.group
  Icons.collections_bookmark_outlined,
  // Icons.local_play_outlined,
  Icons.memory,
];
List<List<dynamic>> _GroupList = [[], [], [], [], [], [], [], []];

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupState();
}

class _GroupState extends State<GroupScreen> {
  var secureStorage;
  var userInfo;
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

  Future<void> _makeGroupList() async {
    _GroupList = await groupSerachforTopic(realThema);
    await _initUserState();
    _GroupList.add([]); //추천 받아오기
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initUserState() async {
    List<dynamic> myList = [];

    try {
      var id = await secureStorage.readData('id');
      var token = await secureStorage.readData('token');
      var _userInfo = await getUserInfo(id, token);
      for (int i = 0; i < _userInfo['clubsList'].length; i++) {
        dynamic temp =
            await groupSerachforId(_userInfo['clubsList'][i]['clubId']);
        myList.add(temp);
      }

      setState(() {
        userInfo = _userInfo;
        _GroupList.add(myList);
      });
    } catch (e) {
      setState(() {
        _GroupList.add(myList);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    _makeGroupList();
    _scrollController.addListener(() {});
    _loadData();
  }

  Future<void> _loadData() async {
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //테마별로 리스트 버튼 구현 + 스크롤 이동 구현
  Widget _ThemaList(
    BuildContext context,
    List<String> Thema,
  ) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate((Thema.length / 4).ceil(), (int i) {
          int startIndex = i * 4;
          int endIndex = (i + 1) * 4;
          if (endIndex > Thema.length) endIndex = Thema.length;

          List<Widget> rowButtons = [];
          for (int j = startIndex; j < endIndex; j++) {
            rowButtons.add(
              SizedBox(
                height: 80.h,
                width: 90.w,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // print('${Thema[j]} 눌렸습니다.');
                        final buttonOffset = j * 135.0.h;
                        _scrollController.animateTo(buttonOffset,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      icon: Icon(
                        ThemaIcon[j],
                      ),
                    ),
                    Text(
                      Thema[j],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    data: _GroupList[index][i],
                    userInfo: userInfo,
                  );
                }),
              ),
            ),
          ],
        ),
        SizedBox(
          height: (index != 7) ? 10.h : 500.h,
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
        floatingActionButton: (userInfo != null)
            ? FloatingActionButton(
                onPressed: () {
                  context.push('/group_make').then((value) async {
                    if (value == true) {
                      _isLoading = true;
                      _loadData();
                      _makeGroupList();
                    }
                  });
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null,
        body: Center(
          child: Column(
            children: [
              Container(
                height: 150.h,
                width: 390.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E9913),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    bottomRight: Radius.circular(50.r),
                  ),
                ),
                child: SizedBox(
                  width: 390.w,
                  height: 90.h,
                  child: _ThemaList(context, Thema),
                ),
              ),
              _isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 100.h),
                        child: const CircularProgressIndicator(),
                      ), // 로딩 애니매이션
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _isLoading = true;
                            _loadData();
                            _makeGroupList();
                          });
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
                              //내 모임
                              groupList(6),
                              //추천
                              groupList(7),
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
