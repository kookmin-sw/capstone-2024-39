import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('로그인'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          backgroundColor: const Color(0xFF0E9913),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 390.w,
                  height: 515.h,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 33.h),
                      Text(
                        '怨꾩젙 濡쒓렇?씤',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 55.h),
                      SizedBox(
                        width: 330.w,
                        height: 39.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0.w,
                              top: 0.h,
                              child: Container(
                                width: 330.w,
                                height: 39.h,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFA8AFB6)),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20.w,
                              child: Expanded(
                                child: SizedBox(
                                  width: 330.w,
                                  child: TextField(
                                    style: const TextStyle(fontSize: 14),
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: '?씠硫붿씪',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: 330.w,
                        height: 39.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0.w,
                              top: 0.h,
                              child: Container(
                                width: 330.w,
                                height: 39.h,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFA8AFB6)),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20.w,
                              child: Expanded(
                                child: SizedBox(
                                  width: 330.w,
                                  child: TextField(
                                    style: const TextStyle(fontSize: 14),
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      hintText: '鍮꾨??踰덊샇',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Align(
                        alignment: FractionalOffset.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Handle forgot password action
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 50.w),
                            child: Text(
                              '鍮꾨??踰덊샇 李얘린',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF747474),
                                fontSize: 10.sp,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      GestureDetector(
                        onTap: () {
                          // Handle login action
                        },
                        child: Container(
                          width: 330.w,
                          height: 39.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E9913),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              '濡쒓렇?씤',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, // ?쇊履? ?젙?젹
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 50.w),
                            child: Text(
                              '怨꾩젙?씠 ?뾾?쑝?떊媛??슂?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push('/signup');
                            },
                            child: Text(
                              '?쉶?썝媛??엯',
                              style: TextStyle(
                                color: const Color(0xFF0E9913),
                                fontSize: 10.sp,
                                fontFamily: 'Noto Sans KR',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFF0E9913),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                      GestureDetector(
                        onTap: () {
                          // Handle Google login action
                        },
                        child: Container(
                          width: 330.w,
                          height: 45.h,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 28.w,
                                height: 28.h,
                                child: AspectRatio(
                                  aspectRatio: 28.0 / 28.0,
                                  child: Image.network(
                                    'https://via.placeholder.com/28x28',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '援ш??濡? 濡쒓렇?씤?븯湲?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontFamily: 'Noto Sans KR',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
