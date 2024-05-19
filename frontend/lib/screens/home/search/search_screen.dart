import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart'
    as GroupUtil;
import 'package:frontend/screens/home/search/search_screen_util.dart'
    as SearchUtil;
import 'package:provider/provider.dart';

List<dynamic> BookData = [];
List<dynamic> GroupData = [];
bool check = false;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  final TextEditingController _textControllers = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var secureStorage;
  var userInfo;
  bool _isLoading = true;

  void _SearchData(String text) async {
    BookData = await SearchBook(text);
    GroupData = await groupSerachforBook(text);
    setState(() {
      _isLoading = true;
      _loadData(700);
      check = true;
    });
  }

  bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  Future<void> _initUserState() async {
    try {
      var id = await secureStorage.readData('id');
      var token = await secureStorage.readData('token');
      var _userInfo = await getUserInfo(id, token);
      setState(() {
        userInfo = _userInfo;
      });
    } catch (e) {
      setState(() {
        userInfo = null;
      });
    }
  }

  void initiate() {
    //초기화 함수
    _scrollController.addListener(() {});
    _initUserState();
    setState(() {
      BookData = [];
      GroupData = [];
      _textControllers.clear();
      check = false;
    });
  }

  Future<void> _loadData(int term) async {
    Timer(Duration(milliseconds: term), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _textControllers.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    initiate();
    _loadData(300);
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
            '검색',
            style: textStyle(22, Colors.white, true),
          ),
          centerTitle: true,
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
                      Container(
                        margin:
                            EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                        padding: EdgeInsets.only(left: 10.w),
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_isFieldEmpty(_textControllers)) {
                                  // 검색 x
                                  // BookData = [];
                                } else {
                                  _SearchData(_textControllers.text);
                                  _scrollController.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                }
                              },
                              icon: const Icon(Icons.search),
                            ),
                            SizedBox(
                              width: 260.w,
                              child: TextField(
                                controller: _textControllers,
                                decoration: InputDecoration(
                                  hintText: '책 제목을 검색해주세요',
                                  hintStyle: textStyle(18, Colors.grey, false),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                ),
                                style: textStyle(18, Colors.black, true),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSubmitted: (value) {
                                  if (_isFieldEmpty(_textControllers)) {
                                    // 검색 x
                                    // BookData = [];
                                  } else {
                                    _SearchData(_textControllers.text);
                                    _scrollController.animateTo(0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              _isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 200.h),
                        child: const CircularProgressIndicator(),
                      ), // 로딩 애니매이션
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        child: Column(
                          children: [
                            if (check && GroupData.isEmpty)
                              Text(
                                "모임 검색 결과가 없습니다.",
                                style: textStyle(15, Colors.black, true),
                              ),
                            ElevatedButton(
                              onPressed: () async {
                                dynamic userInfo =
                                    await login("test13@gmail.com");
                                // dynamic userInfo = await singup("test13@gmail.com", "한지민", ?, "여자");
                                print(userInfo['token']);
                                print(userInfo['id']);
                                await secureStorage.saveData(
                                    "token", userInfo['token']);
                                await secureStorage.saveData(
                                    "id", userInfo['id']);
                              },
                              child: Text('한지민'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                dynamic userInfo =
                                    await login("test80@gmail.com");
                                // dynamic userInfo = await singup("test80@gmail.com", "젠랑이", 7, "남자");
                                print(userInfo['token']);
                                print(userInfo['id']);
                                await secureStorage.saveData(
                                    "token", userInfo['token']);
                                await secureStorage.saveData(
                                    "id", userInfo['id']);
                              },
                              child: Text('젠랑이'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                dynamic userInfo = await login(
                                    "test10@gmail.com"); //10-최창연, 11, 12, 13-한지민, 14, 15, 16
                                // dynamic userInfo = await singup("test10@gmail.com", "최창연", 23, "남자");
                                print(userInfo['token']);
                                print(userInfo['id']);
                                await secureStorage.saveData(
                                    "token", userInfo['token']);
                                await secureStorage.saveData(
                                    "id", userInfo['id']);
                              },
                              child: Text('최창연'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                var token =
                                    await secureStorage.readData("token");
                                var id = await secureStorage.readData("id");
                                print(token);
                                print(id);
                              },
                              child: Text('토큰 확인'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await secureStorage.deleteData("token");
                                await secureStorage.deleteData("id");
                                await secureStorage.deleteAllData();
                              },
                              child: Text('토큰 삭제'),
                            ),
                            if (GroupData.isNotEmpty)
                              SizedBox(
                                height: 200.h, // 높이 조정
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: GroupData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GroupUtil.GroupListItem(
                                        data: GroupData[index],
                                        userInfo: userInfo,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            if (BookData.isNotEmpty)
                              for (int i = 0; i < BookData.length; i++)
                                SearchUtil.SearchListItem(
                                  data: BookData[i],
                                  type: "search",
                                  clubId: 0,
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

TextStyle textStyle(int fontsize, Color color, bool isStroke) {
  return TextStyle(
    fontSize: fontsize.sp,
    fontWeight: (isStroke)?FontWeight.bold : FontWeight.normal,
    fontFamily: 'Noto Sans KR',
    color: color,
  );
}
