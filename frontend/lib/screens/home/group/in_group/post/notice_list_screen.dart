import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';

//공지사항 목록 페이지

class NoticeListScreen extends StatefulWidget {
  final String managerId;
  final int clubId;

  const NoticeListScreen({
    super.key,
    required this.managerId, 
    required this.clubId,
  });

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  List<dynamic> posts = [];

  Future<void> updatePostList() async {
    var clubData = await groupSerachforId(widget.clubId);
    setState(() {
      posts = clubData['posts'];
    });
  }

  @override
  void initState() {
    super.initState();
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
            '공지사항',
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
            context.push(
              '/post_make',
              extra: {
                'managerId': widget.managerId,
                'clubId': widget.clubId,
              },
            ).then((result) async {
              if (result == true) {
                updatePostList();
              }
            });
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(posts),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPostListView(List<dynamic> Postdata) {
    List<Widget> items = [];

    for (Map<String, dynamic> post in Postdata) {
      if (post['isSticky']) {
        items.add(
          Column(
            children: [
              SizedBox(
                height: 58.h,
                width: double.infinity,
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      context.push(
                        '/post',
                        extra: {
                          "postId": post['id'],
                          "clubId": post['clubId'],
                        },
                      );
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
    }
    return items;
  }
}
