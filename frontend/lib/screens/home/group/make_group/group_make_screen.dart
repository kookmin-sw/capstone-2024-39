import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/env.dart';

//모임 생성 페이지

class GroupMakeScreen extends StatefulWidget {
  const GroupMakeScreen({
    super.key,
  });

  @override
  State<GroupMakeScreen> createState() => _GroupMakeState();
}

class _GroupMakeState extends State<GroupMakeScreen> {
  //공개, 비공개
  final List<bool> _isPublic = [true, false];
  //각 항목을 입력했는지 확인
  final List<bool> _enableCreateGroup = [false, false, false, false];

  final List<TextEditingController> _textControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  bool _isCreateButtonEnabled() {
    //공개
    if (_isPublic[0]) {
      for (int check = 0; check < _enableCreateGroup.length - 1; check++) {
        if (!_enableCreateGroup[check]) {
          return false;
        }
      }
    }
    //비공개
    else if (_isPublic[1]) {
      for (int check = 0; check < _enableCreateGroup.length; check++) {
        if (!_enableCreateGroup[check]) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('모임생성'),
          titleTextStyle: textStyle(22, const Color(0xFF0E9913), true),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 모임 이름 설정
              TextField(
                controller: _textControllers[0],
                decoration: const InputDecoration(
                  labelText: '모임 이름',
                  hintText: '모임이름',
                ),
                onChanged: (value) {
                  setState(() {
                    _enableCreateGroup[0] = !_isFieldEmpty(_textControllers[0]);
                  });
                },
              ),
              SizedBox(height: 16.h),
              // 모임 주제 설정
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: '모임 주제',
                ),
                items: realThema
                    .map((theme) => DropdownMenuItem(
                          value: theme,
                          child: Text(theme),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _textControllers[1].text = value.toString();
                    _enableCreateGroup[1] = !_isFieldEmpty(_textControllers[1]);
                  });
                },
              ),
              SizedBox(height: 16.h),
              // 모임 제한 인원
              TextField(
                controller: _textControllers[2],
                decoration: const InputDecoration(
                  labelText: '모임 제한인원',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {
                    _enableCreateGroup[2] = !_isFieldEmpty(_textControllers[2]);
                  });
                },
              ),
              SizedBox(height: 16.h),
              // 공개 비공개 여부
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Text('Public'),
                  // CupertinoSwitch(
                  //   value: _isPublic[0],
                  //   onChanged: (value) {
                  //     setState(() {});
                  //   },
                  // ),
                  ToggleButtons(
                    isSelected: _isPublic,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (index) {
                      setState(() {
                        _textControllers[3].clear();
                        _enableCreateGroup[3] =
                            !_isFieldEmpty(_textControllers[3]);
                        for (int buttonIndex = 0;
                            buttonIndex < _isPublic.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _isPublic[buttonIndex] = !_isPublic[buttonIndex];
                          } else {
                            _isPublic[buttonIndex] = !_isPublic[buttonIndex];
                          }
                        }
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '공개',
                          style: textStyle(14, null, false),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '비공개',
                          style: textStyle(14, null, false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // 비밀번호
              if (_isPublic[1])
                TextField(
                  controller: _textControllers[3],
                  decoration: const InputDecoration(
                      labelText: '비밀번호',
                      border: OutlineInputBorder(),
                      hintText: '****'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      _enableCreateGroup[3] =
                          !_isFieldEmpty(_textControllers[3]);
                    });
                  },
                ),
              SizedBox(height: 16.h),
              // 생성하기 버튼
              ElevatedButton(
                onPressed: _isCreateButtonEnabled()
                    ? (int.parse(_textControllers[2].text) == 0)
                        ? () {
                            _showLimitDialog(context);
                          }
                        : () async {
                            //모임 목록을 백으로 보내는 코드 작성
                            String publication;
                            dynamic result;
                            var token = await secureStorage.readData("token");
                            if (_isPublic[0]) {
                              publication = '공개';
                              result = await groupCreate(
                                  token,
                                  _textControllers[0].text,
                                  _textControllers[1].text,
                                  int.parse(_textControllers[2].text),
                                  publication,
                                  null);
                            } else {
                              publication = '비공개';
                              result = await groupCreate(
                                  token,
                                  _textControllers[0].text,
                                  _textControllers[1].text,
                                  int.parse(_textControllers[2].text),
                                  publication,
                                  int.parse(_textControllers[3].text));
                            }

                            if (result.toString() == "모임 생성 완료") {
                              context.pop(true);
                            } else {
                              // 모임 생성 실패시 코드 작성
                            }
                          }
                    : null,
                child: Text(
                  '생성하기',
                  style: textStyle(13, null, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 모임인원이 0명인 경우
void _showLimitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('제한인원 설정 오류'),
        titleTextStyle: textStyle(20, Colors.black, true),
        content: const Text('모임 제한 인원은\n최소 1명 이상으로 설정해야 합니다.'),
        contentTextStyle: textStyle(14, Colors.black, false),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "확인",
              style: textStyle(13, null, false),
            ),
          ),
        ],
      );
    },
  );
}
