import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

//멤버들 과제 리스트

class HomeworkMemberlistScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final int clubId;

  const HomeworkMemberlistScreen({
    super.key,
    required this.post,
    required this.clubId,
  });

  @override
  State<HomeworkMemberlistScreen> createState() => _HomeworkMemberistState();
}

class _HomeworkMemberistState extends State<HomeworkMemberlistScreen> {
  List<dynamic> HwList = [];
  var secureStorage;
  var id;
  var token;

  Future<void> initUserInfo() async {
    var _id = await secureStorage.readData("id");
    var _token = await secureStorage.readData("token");
    setState(() {
      id = _id;
      token = _token;
    });
  }

  Future<void> updateHwList() async {
    var _token = await secureStorage.readData("token");
    var _posts = await getAssign(_token, widget.clubId);
    var _HwList;
    for (Map<String, dynamic> Hw in _posts) {
      if (Hw['id'] == widget.post['id']) {
        _HwList = Hw['contentList'];
        break;
      }
    }
    setState(() {
      HwList = _HwList;
    });
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    initUserInfo();
    updateHwList();
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
            widget.post['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: _buildHWListView(widget.post['contentList']),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHWListView(List<dynamic> posts) {
    List<Widget> items = [];

    for (Map<String, dynamic> post in posts) {
      items.add(
        Column(
          children: [
            SizedBox(
              height: 58.h,
              width: double.infinity,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return items;
  }
}
