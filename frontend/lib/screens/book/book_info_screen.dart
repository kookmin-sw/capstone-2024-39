import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BookInfoScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const BookInfoScreen({
    super.key,
    required this.data,
  });

  @override
  State<BookInfoScreen> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfoScreen> {
  List<bool> _selectType = [true, false, false];

  List<Widget> postType(BuildContext context, List<String> type) {
    List<Widget> temp = [];
    for (int i = 0; i < _selectType.length; i++) {
      temp.add(Padding(
        padding: EdgeInsets.only(
          left: (i == 0) ? 24.0 : 0,
          right: 5.0,
        ),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              setState(() {
                for (int j = 0; j < _selectType.length; j++) {
                  if (i == j) {
                    _selectType[j] = true;
                  } else {
                    _selectType[j] = false;
                  }
                }
              });
            },
            child: Text(
              type[i],
              style: TextStyle(
                color: _selectType[i] ? Color(0xFF0E9913) : Colors.black,
                fontSize: 16,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ));
    }
    return temp;
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
            widget.data['title'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180.h,
              decoration: const BoxDecoration(
                color: Color(0xFF0E9913),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Container(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            width: ScreenUtil().setWidth(80),
                            height: ScreenUtil().setHeight(105),
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.data['image']),
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          bottom: 20.0,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            child: Text(
                              widget.data['description'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Ink(
                      width: 350.w,
                      height: 120.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          context.push('/homework_list');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 5.0,
                                top: 3.0,
                              ),
                              child: Text(
                                '퀴즈',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Noto Sans KR',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          children: postType(context, ['독후감', '인용구', '한줄']),
                        ),
                        Ink(
                          width: 350.w,
                          height: 120.h,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              context.push('/homework_list');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
