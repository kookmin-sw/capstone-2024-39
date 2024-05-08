import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MakeLibraryScreen extends StatefulWidget {
  const MakeLibraryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MakeLibraryScreenState createState() => _MakeLibraryScreenState();
}

class _MakeLibraryScreenState extends State<MakeLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('서재 이름'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          backgroundColor: const Color(0xFF0E9913),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              padding: EdgeInsets.only(left: 10.w),
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Text('책 제목을 검색해주세요'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
