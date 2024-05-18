import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

//과제 목록 페이지

class HomeworkListScreen extends StatefulWidget {
  final String managerId;
  final int clubId;

  const HomeworkListScreen({
    super.key,
    required this.managerId,
    required this.clubId,
  });

  @override
  State<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends State<HomeworkListScreen> {
  List<dynamic> posts = [];
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

  Future<void> updatePostList() async {
    var _posts = await getAssign(widget.clubId);
    if(_posts.runtimeType == Map<String,dynamic>){
      _posts = [];
    }
    setState(() {
      posts = _posts;
    });
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    initUserInfo();
    updatePostList();
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
            '과제',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: (id == widget.managerId)
            ? FloatingActionButton(
                onPressed: () {
                  context
                      .push(
                    '/homework_make',
                    extra: widget.clubId,
                  )
                      .then((result) async {
                    if (result == true) {
                      updatePostList();
                    }
                  });
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(posts),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPostListView(List<dynamic> posts) {
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
                    context.push('/homeworkmember_make', extra: {
                      'post': post,
                      'clubId': widget.clubId,
                    }); 
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post['name'],
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
