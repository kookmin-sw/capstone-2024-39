import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BookInfoScreen extends StatefulWidget {
  final String bookName;

  const BookInfoScreen({
    super.key,
    required this.bookName,
  });

  @override
  State<BookInfoScreen> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFF0E9913),
            title: Text(
              widget.bookName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: Expanded(
            child: Container(
              width: 390,
              height: 508,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 47),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 350,
                    height: 143,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 202,
                          child: Text(
                            '원씽(The One Thing)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w700,
                              height: 0.06,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 142.79,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/100x143"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ),
                        SizedBox(
                          width: 202,
                          child: Text(
                            '게리 켈러, 제이 파파산 | 비즈니스북스',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w700,
                              height: 0.38,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 202,
                          height: 87,
                          child: Text(
                            '전 세계에서 두 번째로 큰 투자개발 회사의 대표이자 전미 130만 부 이상이 팔린 베스트셀러의 저자 게리 캘러가 쓴 이제까지의 통념을 뒤엎는 신개념 자기계발서이다.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w400,
                              height: 0.14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 350,
                    height: 120,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 350,
                            height: 120,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 6.46,
                          top: 3.60,
                          child: SizedBox(
                            width: 24.77,
                            height: 28.80,
                            child: Text(
                              '퀴즈',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                                height: 0.17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 350,
                    height: 139,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 19,
                          child: Container(
                            width: 350,
                            height: 120,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 6.46,
                          top: -0,
                          child: SizedBox(
                            width: 36.62,
                            height: 28,
                            child: Text(
                              '독후감',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                                height: 0.17,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 56,
                          top: -0,
                          child: SizedBox(
                            width: 36.62,
                            child: Text(
                              '한줄평',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                                height: 0.17,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 112,
                          top: -0,
                          child: SizedBox(
                            width: 24.77,
                            child: Text(
                              '인용',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                                height: 0.17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
