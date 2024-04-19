import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/home/group/group_screen.dart';

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
  final List<bool> _enableCreateGroup = [false, false, false, false, false];

  final List<TextEditingController> _textControllers = List.generate(5, (index) => TextEditingController(),); 
  
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
    if(_isPublic[0]){
      for(int check = 0; check < _enableCreateGroup.length - 1; check++){
        if(!_enableCreateGroup[check]){
          return false;
        }
      }
    }
    //비공개
    else if(_isPublic[1]){
      for(int check = 0; check < _enableCreateGroup.length; check++){
        if(!_enableCreateGroup[check]){
          return false;
        }
      }
    }
    return true; 
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 675),
      builder:(context, child) => Scaffold(
        appBar: AppBar(
          title: Text('모임생성'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 모임 이름 설정
              TextField(
                controller: _textControllers[0],
                decoration: InputDecoration(
                  labelText: '모임 이름',
                  hintText: '모임이름',
                ),
                onChanged: (value){
                  setState(() {
                    _enableCreateGroup[0] = !_isFieldEmpty(_textControllers[0]);  
                  });
                },
              ),
              SizedBox(height: 16.0),
              // 대표 책 설정
              TextField(
                controller: _textControllers[1],
                decoration: InputDecoration(
                  labelText: '대표 책',
                  hintText: '대표책',
                ),
                onChanged: (value){
                  setState(() {
                    _enableCreateGroup[1] = !_isFieldEmpty(_textControllers[1]);  
                  });
                },
              ),
              SizedBox(height: 16.0),
              // 모임 주제
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: '모임 주제',
                ),
                items: Thema.map((theme) => DropdownMenuItem(
                  value: theme,
                  child: Text(theme),
                )).toList(),
                onChanged: (value){
                  setState(() {
                    _textControllers[2].text = value.toString();
                    _enableCreateGroup[2] = !_isFieldEmpty(_textControllers[2]);
                  });
                },
              ),
              SizedBox(height: 16.0),
              // 모임 제한 인원
              TextField(
                controller: _textControllers[3],
                decoration: InputDecoration(
                  labelText: '모임 제한인원',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value){
                  setState(() {
                    _enableCreateGroup[3] = !_isFieldEmpty(_textControllers[3]);
                  });
                },
              ),
              SizedBox(height: 16.0),
              // 공개 비공개 여부
              Row(
                children: [
                  Text('Public'),
                  CupertinoSwitch(
                    value: _isPublic[0],
                    onChanged: (value) {
                      setState(() {
                      });
                    },
                  ),
                  Container(
                    child: ToggleButtons(
                      isSelected: _isPublic,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (index){
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < _isPublic.length; buttonIndex++) {
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
                          child: Text('공개'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('비공개'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // 비밀번호 
              if (_isPublic[1])
                TextField(
                  controller: _textControllers[4],
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                    hintText: '****'
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    setState(() {
                      _enableCreateGroup[4] = !_isFieldEmpty(_textControllers[4]);  
                    });
                  },
                ),
              SizedBox(height: 16.0),
              // 생성하기 버튼
              ElevatedButton(
                onPressed: _isCreateButtonEnabled() ? (){
                  //모임 목록을 백으로 보내는 코드 작성
                } : null,
                child: Text(
                  '생성하기',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


