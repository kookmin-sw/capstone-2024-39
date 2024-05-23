import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/env.dart';

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
      List<dynamic> temp = clubData['posts'];
      if (temp.isNotEmpty) {
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["createdAt"]);
          DateTime dateTimeB = DateTime.parse(b["createdAt"]);
          return dateTimeB.compareTo(dateTimeA);
        });
      }
      posts = temp;
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
          title: Text(
            '게시판',
            style: textStyle(22, Colors.white, true),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w, top: 10.w),
                                child: Text(
                                  post['title'],
                                  style: textStyle(20, null, false),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  "작성자 ${post['writer']}",
                                  style: textStyle(12, null, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 14.w, bottom: 5.h, top: 5.h),
                                child: Text(
                                  formatDate(post['createdAt']),
                                  style: textStyle(12, Colors.grey, false),
                                ),
                              ),
                              (post['isSticky'])
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 14.w),
                                      child: Text('공지사항',
                                          style:
                                              textStyle(12, Colors.red, true)),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 30.w,
                          height: 47.h,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE4E7EA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  '${post['commentResponseList'].length}',
                                  style: textStyle(13, null, false),
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                '댓글',
                                style: textStyle(13, Colors.grey, false),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
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
