import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/http.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력하세요';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return '나이를 입력하세요';
    }
    int? age = int.tryParse(value);
    if (age == null || age < 1 || age > 99) {
      return '나이는 1에서 99 사이여야 합니다';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return '성별을 입력하세요';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
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
              Navigator.pop(context);
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
                        '계정 만들기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 33.h),
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
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      hintText: '이름',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
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
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    controller: _ageController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: '나이',
                                      border: InputBorder.none,
                                    ),
                                    validator: _validateAge,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
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
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    controller: _genderController,
                                    decoration: const InputDecoration(
                                      hintText: '성별',
                                      border: InputBorder.none,
                                    ),
                                    validator: _validateAge,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      GestureDetector(
                        onTap: () async {
                          if (_validateAge(_ageController.text) == null &&
                              _validateName(_nameController.text) == null &&
                              _validateGender(_genderController.text) == null) {
                            final secureStorage =
                                Provider.of<SecureStorageService>(context,
                                    listen: false);
                            await singup(
                                (await secureStorage.readData("userID")) ?? '',
                                _nameController.text,
                                int.parse(_ageController.text),
                                _genderController.text);
                            await secureStorage.saveData(
                                'name', _nameController.text);
                            await secureStorage.saveData(
                                'age', _ageController.text);
                            await secureStorage.saveData(
                                'gender', _genderController.text);
                            print("성공");
                            context.pop();
                          } else {
                            print("실패");
                          }
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
                              '회원가입',
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
