import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

//그룹 탭의 리스트 아이템 템플릿

class GroupListItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final userInfo;

  const GroupListItem({
    super.key,
    required this.data,
    required this.userInfo,
  });

  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
  final bool LoginCheck = true;

  bool memberCheck(dynamic data) {
    print(data);
    if(widget.userInfo == null){
      return false;
    }
    for (dynamic member in data['memberList']) {
      if (member['id'] == widget.userInfo['id']) {
        return true;
      }
    }
    return false;
  }

  void goGroup(dynamic data) {
    context.push('/group_info', extra: {
      'groupName': data['name'],
      'id': data['id'],
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ink(
          width: ScreenUtil().setWidth(170),
          height: ScreenUtil().setHeight(95),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Color(0xFFEEF1F4),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: InkWell(
            onTap: () async {
              if (widget.data['publicstatus'] == "PUBLIC") {
                // 공개
                goGroup(widget.data);
              } else {
                //비공개
                if (memberCheck(widget.data)) {
                  //멤버인 경우
                  goGroup(widget.data);
                } else {
                  //멤버 아닌 경우
                  switch (await _showPasswordDialog(
                      context, widget.data['password'])) {
                    case 1:
                      //비번 맞춤
                      goGroup(widget.data);
                      break;
                    case 0:
                      //비번 못 맞춤
                      _showWrongDialog(context);
                      break;
                    case 2:
                      //비번 입력도 안함
                      break;
                    default:
                      break;
                  }
                }
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Row(
              children: [
                (widget.data['book'] != null)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Container(
                          // 책사진 넣는 곳
                          width: 40.w,
                          height: 60.h,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage(widget.data['book']['imageUrl']),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 40.w,
                        height: 60.h,
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(7),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('주제:${widget.data['topic']}',
                            style: TextStyle(fontSize: 13.sp)),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        Text(
                          widget.data['name'],
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(3),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: ScreenUtil().setWidth(13),
                              color: (widget.data['memberCnt'] ==
                                      widget.data['maximum'])
                                  ? Colors.red
                                  : null,
                            ), // 인원수 아이콘
                            SizedBox(width: 3.w),
                            Text(
                                '${widget.data['memberCnt']} / ${widget.data['maximum']}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: (widget.data['memberCnt'] ==
                                          widget.data['maximum'])
                                      ? Colors.red
                                      : null,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(3),
                        ),
                        Text(
                            (widget.data['publicstatus'] == 'PUBLIC')
                                ? '공개'
                                : '비공개',
                            style: TextStyle(fontSize: 13.sp)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
      ],
    );
  }
}

// 비밀번호 틀린 경우
void _showWrongDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('비밀번호를 틀렸습니다.'),
        content: Text('다시 입력해주세요.'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("확인"),
          ),
        ],
      );
    },
  );
}

// 비밀번호 입력하기
Future<int> _showPasswordDialog(BuildContext context, int password) async {
  final TextEditingController _textController = TextEditingController();
  return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("비밀번호를 입력해주세요."),
            content: TextField(
              controller: _textController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: "****",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_textController.text.trim().isNotEmpty) {
                    if (int.parse(_textController.text) == password) {
                      context.pop(1);
                    } else {
                      context.pop(0);
                    }
                  }
                },
                child: const Text("확인"),
              ),
            ],
          );
        },
      ) ??
      2; //기본값 2
}
