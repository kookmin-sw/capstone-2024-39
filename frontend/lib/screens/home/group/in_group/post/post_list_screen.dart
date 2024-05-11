import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/home/group/in_group/post/post_screen.dart';

//게시글 목록 페이지

List<Widget> _buildPostListView(BuildContext context, List<dynamic> Postdata) {
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
                          padding: const EdgeInsets.only(
                            left: 10.0),
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

class PostListScreen extends StatefulWidget {
  final List<dynamic> posts;
  const PostListScreen({
    super.key,
    required this.posts,
  });

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
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
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(context, widget.posts),
          ),
        ),
      ),
    );
  }
}
