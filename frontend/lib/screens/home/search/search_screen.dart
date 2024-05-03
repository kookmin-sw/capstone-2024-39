import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';

List<dynamic> token = [];


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder:(context, child) => Scaffold(
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
                height: 120.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E9913),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          context.push(
                            '/book_info',
                            extra: '썸띵',
                          );
                        }, 
                        child: Text('test'),
                      ),
                      ElevatedButton(
                        onPressed: ()async{
                          token = [];
                          token.add(singup("test4@gmail.com", "최연습", 33, "여자"));
                          token.add(singup("test5@gmail.com", "한연습", 37, "남자"));
                          token.add(singup("test6@gmail.com", "석연습", 46, "여자"));
                        }, 
                        child: Text('회원가입'),
                      ),
                      ElevatedButton(
                        onPressed: ()async{
                          token = [];
                          token.add(login("test4@gmail.com"));
                          token.add(login("test5@gmail.com"));
                          token.add(login("test6@gmail.com"));
                        }, 
                        child: Text('로그인'),
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