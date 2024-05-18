import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:go_router/go_router.dart';

//게시글 목록 페이지

class PostListScreen extends StatefulWidget {
  final String managerId;
  final int clubId;

  const PostListScreen(
      {super.key, required this.managerId, required this.clubId});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
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
            '게시판',
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
      items.add(
        Column(
          children: [
            SizedBox(
              height: 58.h,
              width: double.infinity,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    context.push('/post', extra: {
                      "postId": post['id'],
                      "clubId": post['clubId'],
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      (post['isSticky'])
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                '공지사항',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5.w,
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
