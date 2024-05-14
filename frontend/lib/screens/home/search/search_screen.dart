import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/screens/home/search/search_screen_util.dart'
    as SearchUtil;
import 'package:frontend/screens/home/group/group_screen_util.dart'
    as GroupUtil;
import 'package:frontend/provider/secure_storage_provider.dart';
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

  void _SearchData(String text) async {
    BookData = await SearchBook(text);
    GroupData = await groupSerachforBook(text);
    setState(() {});
  }

  bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  void initiate() {
    //초기화 함수
    _scrollController.addListener(() {});
    setState(() {
      BookData = [];
      GroupData = [];
      _textControllers.clear();
      check = false;
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
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFF0E9913),
          title: const Text(
            '검색',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120),
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
                          SizedBox(
                            width: ScreenUtil().setWidth(280),
                            child: TextField(
                              controller: _textControllers,
                              decoration: const InputDecoration(
                                hintText: '검색어',
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_isFieldEmpty(_textControllers)) {
                                // 검색 x
                                // BookData = [];
                              } else {
                                _SearchData(_textControllers.text);
                                _scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                                setState(() {
                                  check = true;
                                });
                              }
                            },
                            icon: const Icon(Icons.search),
                          )
                        ],
                      ),
                    ],
                  )),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  child: Column(
                    children: [
                      if (check && GroupData.isEmpty) Text("검색 결과가 없습니다"),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/bookreport_viewing');
                        },
                        child: Text('테스트'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          dynamic userInfo = await login(
                              "test10@gmail.com"); //10-최창연, 11, 12, 13-한지민, 14, 15, 16
                          // dynamic userInfo = await singup("test16@gmail.com", "랑데부", 24, "남자");
                          print(userInfo['token']);
                          print(userInfo['id']);
                          await secureStorage.saveData(
                              "token", userInfo['token']);
                          await secureStorage.saveData("id", userInfo['id']);
                        },
                        child: Text('최창연'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var token = await secureStorage.readData("token");
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
                          height: 200, // 높이 조정
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: GroupData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GroupUtil.GroupListItem(
                                  id: GroupData[index]['id'],
                                  groupName: GroupData[index]['name'],
                                  groupCnt: GroupData[index]['maximum'],
                                  publicState: GroupData[index]['publicStatus'],
                                  topic: GroupData[index]['topic'],
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
