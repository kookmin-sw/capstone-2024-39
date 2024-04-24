import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/home/group/in_group/post/post_screen.dart';

//게시글 목록 페이지

List<String> Test_post = ['연습1', '연습2', '연습3'];
List<String> R_data = [];


Future<List<String>> fetchDataFromDatabase() async {
  // 여기에 데이터베이스에서 데이터를 가져오는 비동기 작업 수행
  // 예를 들어, 데이터베이스 쿼리를 실행하여 데이터를 가져옴
  // 가져온 데이터는 List<String> 형태로 반환
  return ['route1', 'route2', 'route3'];
}

List<Widget> _buildPostListView(BuildContext context, List<String> postTitles) {
  List<Widget> items = [];

  for (String postTitle in postTitles) {
    items.add(
      Column(
        children: [
          SizedBox(
            height: 58.h,
            width: double.infinity,
            child: Ink(
              child: InkWell(
                onTap: (){
                  context.push(
                    '/post',
                    extra: {
                      'title': postTitle,
                      'body': postTitle,
                    }
                  );
                },
                child: Text(
                  postTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
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
                  width: 1,
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
  const PostListScreen({super.key});

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
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(context,Test_post),
          ),
        ),
      ),
    );
  }
}