import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/env.dart';
//모임 생성 페이지

class HomeworkMakeScreen extends StatefulWidget {
  final int clubId;

  const HomeworkMakeScreen({
    super.key,
    required this.clubId,
  });

  @override
  State<HomeworkMakeScreen> createState() => _HomeworkMakeState();
}

class _HomeworkMakeState extends State<HomeworkMakeScreen> {
  var secureStorage;
  final List<String> type = ["독후감", "인용구", "한줄평", "퀴즈"];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  //각 항목을 입력했는지 확인
  bool _enableName = false;
  bool _enableType = false;
  bool _enableDate = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  bool _isCreateButtonEnabled() {
    if (_enableName && _enableDate && _enableType) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('과제 만들기'),
          titleTextStyle: textStyle(22, const Color(0xFF0E9913), true),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 과제 이름 설정
              TextField(
                controller: _nameController,
                style: textStyle(18, null, false),
                decoration: InputDecoration(
                  labelText: '과제 이름',
                  hintText: '과제명',
                  labelStyle: textStyle(18, null, true),
                  hintStyle: textStyle(16, Colors.grey, false),
                ),
                onChanged: (value) {
                  setState(() {
                    _enableName = !_isFieldEmpty(_nameController);
                  });
                },
              ),
              SizedBox(height: 16.h),
              // 과제 타입 설정
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: '과제 주제',
                  labelStyle: textStyle(18, null, true),
                ),
                items: type
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: textStyle(18, null, false),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _typeController.text = value.toString();
                    _enableType = !_isFieldEmpty(_typeController);
                  });
                },
              ),
              SizedBox(height: 16.h),
              // 기한 설정
              dueDate(),
              SizedBox(height: 16.h),
              // 생성하기 버튼
              ElevatedButton(
                onPressed: _isCreateButtonEnabled()
                    ? () async {
                        //모임 목록을 백으로 보내는 코드 작성
                        var token = await secureStorage.readData("token");
                        String result = await assignCreate(
                            token,
                            widget.clubId,
                            _nameController.text,
                            _typeController.text,
                            _startDate.toString().substring(0, 10),
                            _endDate.toString().substring(0, 10));
                        if (result == '과제 생성 완료') {
                          context.pop();
                        }
                      }
                    : null,
                child: Text(
                  '생성하기',
                  style: textStyle(14, null, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dueDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          "기한 설정",
          style: textStyle(18, null, true),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _startDate) {
                  setState(() {
                    _startDate = picked;
                    _enableDate = !_startDate.isAfter(_endDate);
                  });
                }
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 5)),
              ),
              child: Text(_startDate.toString().substring(0, 10)),
            ),
            const Text(' ~ '),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _endDate) {
                  setState(() {
                    if (picked.toString().substring(0, 10) ==
                        _endDate.toString().substring(0, 10)) {
                    } else {
                      _endDate = picked;
                    }
                    _enableDate = !_startDate.isAfter(_endDate);
                  });
                }
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 5)),
              ),
              child: Text(_endDate.toString().substring(0, 10)),
            ),
          ],
        ),
      ],
    );
  }
}
