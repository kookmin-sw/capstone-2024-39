import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

//그룹 상세 페이지
//setState가 필요한 함수들은 클래스 안에 있어야 함

class GroupInfoScreen extends StatefulWidget {
  final String groupName;

  const GroupInfoScreen({
    super.key,
    required this.groupName,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfoScreen> {
  //drawer 상태관리
  bool _isDrawerOpen = false;
  //그룹의 모임원 여부
  bool _isGroupMember = true;
  //그룹의 모임장 여부
  bool _isGroupManager = true;
  //그룹원(모임원, 모임장)이 설정을 누른지 확인
  bool _isManage = false;
  //모임장의 기능 확인 (true - 추방, flase - 권한 위임)
  bool _isKicked = false;
  //예시 멤버
  List<String> _member = ['홍길동', '최창연', '정지환', '이현준'];
  // 멤버들의 체크 상태를 저장하는 리스트
  List<bool> _memberCheckStates = [false, false, false, false];
  // 체크박스 타켓 인덱스
  int _targetIndex = 0;

  //각 게시판의 글들을 리스트로 형성
  List<Widget> _buildTaskList(
      BuildContext context, int entryCase, String postName) {
    List<Widget> tasks = [];
    for (int i = 0; i < entryCase; i++) {
      tasks.add(_buildTaskEntry(context, i, postName));
      tasks.add(Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ));
    }
    return tasks;
  }

  //각 게시판의 최신글
  Widget _buildTaskEntry(BuildContext context, int index, String entryName) {
    return InkWell(
      onTap: () {
        //글 목록 탭 됐을 때
        print('${entryName} ${index + 1} 탭됨');
      },
      child: Container(
        width: 50.w,
        margin: const EdgeInsets.only(bottom: 2), // 각 항목 사이의 간격 설정
        padding: const EdgeInsets.all(4), // 내부 패딩 설정
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 3.0,
          ),
          child: Text(
            '$entryName${index + 1}',
          ),
        ),
      ),
    );
  }

  // _member 리스트를 이용하여 _memberCheckStates 초기화
  void _initializeMemberCheckStates() {
    _memberCheckStates = List.filled(_member.length, false);
  }

  // 모임 목록을 만드는 함수
  List<Widget> _generateMemberList(BuildContext context) {
    List<Widget> memberList = [];

    for (int i = 0; i < _member.length; i++) {
      memberList.add(_generateMember(context, _member[i], i));
      memberList.add(const Divider());
    }

    return memberList;
  }

  // 모임원 한명씩 생성
  Widget _generateMember(BuildContext context, String memName, int index) {
    return ListTile(
      title: Text(memName),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      trailing: Visibility(
        visible: _isManage && _isGroupManager,
        child: Checkbox(
          value: _memberCheckStates[index],
          onChanged: (newValue) {
            setState(() {
              _memberCheckStates[index] = newValue ?? false;
              _updateCheckStates(index);
            });
          },
        ),
      ),
    );
  }

  // 모임원 체크 박스 업데이트
  void _updateCheckStates(int index) {
    for (int i = 0; i < _memberCheckStates.length; i++) {
      if (i != index) {
        setState(() {
          _memberCheckStates[i] = false;
        });
      }
    }
  }

  // drawer가 닫히면 체크 박스 초기화
  void _handleDrawerStateChanged(bool isOpen) {
    setState(() {
      _isDrawerOpen = isOpen;
    });
    if (!_isDrawerOpen) {
      _isManage = false;
      _initializeMemberCheckStates();
    }
  }

  //모임원 목록 사이드 바
  Widget _buildGroupList(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xffE7FFEB),
            ),
            child: Column(
              children: [
                IconButton(
                    onPressed: () async {
                      // 모임장일땐 설정 버튼이 보이도록
                      if (_isGroupManager) {
                        _showKickedDialog(context);
                      }
                      // 그냥 모임원이면 나가기 버튼이 있도록
                      else {
                        bool check = await _showExitDialog(context);
                        if (check) {
                          // 나가기 요청
                          print('checking');
                          _isGroupMember = false;
                        }
                      }
                    },
                    icon: _isGroupManager
                        ? const Icon(Icons.settings)
                        : const Icon(Icons.logout)),
                const Text(
                  'Side Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // 모임원 리스트 생성(list <Widget>)
          ..._generateMemberList(context),
          // 모임원의 상태 적용 - 모임장만 보이도록
          Visibility(
            visible: _isManage && _isGroupManager,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // 추방할 때
                  bool result = await _showLastConfirmationDialog(context);

                  if (_isKicked) {
                    if (result) {
                      //추방 O
                      setState(() {
                        for (int i = 0; i < _memberCheckStates.length; i++) {
                          if (_memberCheckStates[i]) {
                            _targetIndex = i;
                            break;
                          }
                        }
                        _member.removeAt(_targetIndex);
                        _memberCheckStates.removeAt(_targetIndex);
                        // print(_memberCheckStates.length);
                        _isKicked = false;
                        _isManage = false;
                      });
                    } else {
                      //추방 취소
                    }
                  }
                  // 모임장 위임할 때
                  else {
                    setState(() {
                      for (int i = 0; i < _memberCheckStates.length; i++) {
                        if (_memberCheckStates[i]) {
                          _targetIndex = i;
                          break;
                        }
                      }
                      // 서버에 요청하는 함수
                      _member.removeAt(_targetIndex);
                      _memberCheckStates.removeAt(_targetIndex);
                      // print(_memberCheckStates.length);
                      _isKicked = false;
                      _isManage = false;
                    });
                  }
                  // 원래대로 초기화
                },
                child: const Text(
                  '확인',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 나가기 구현
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("마지막으로 확인하시겠습니까?"),
              content: Text("나가시겠습니까?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // 취소 버튼 클릭 시 false 반환
                  },
                  child: Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // 확인 버튼 클릭 시 true 반환
                  },
                  child: Text("확인"),
                ),
              ],
            );
          },
        ) ??
        false; // showDialog의 기본값은 false로 설정
  }

  //추방 & 임명 구분하기
  void _showKickedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('추방하기'),
                  onTap: () {
                    setState(() {
                      _isKicked = true;
                      _isManage = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('모임장 위임하기'),
                  onTap: () {
                    setState(() {
                      _isKicked = false;
                      _isManage = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 마지막으로 확인하는 알림 창을 표시
  Future<bool> _showLastConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("마지막으로 확인하시겠습니까?"),
              content: Text("추방하시겠습니까?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // 취소 버튼 클릭 시 false 반환
                  },
                  child: Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // 확인 버튼 클릭 시 true 반환
                  },
                  child: Text("확인"),
                ),
              ],
            );
          },
        ) ??
        false; // showDialog의 기본값은 false로 설정
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
          // backgroundColor: Color(0xffE7FFEB),
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFF0E9913),
            title: Text(widget.groupName),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Visibility(
                  visible: !_isGroupMember,
                  child: Ink(
                    width: 70.w,
                    height: 30.h,
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
                      onTap: () {
                        // 회원 가입 동작
                        setState(() {
                          _isGroupMember = true;
                        });
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: const Center(
                        child: Text(
                          '가입하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Noto Sans KR',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    //멤버일 경우만 회원목록을 보도록
                    visible: _isGroupMember,
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
          endDrawer: _isGroupMember ? _buildGroupList(context) : null,
          onEndDrawerChanged: _handleDrawerStateChanged,
          body: Center(
            child: Column(
              children: [
                Container(
                  // width: ,
                  height: 295,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF0E9913),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Center(
                          child: SizedBox(
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
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 38.h,
                        ),
                        //과제
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
                                    '과제',
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
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    children: _buildTaskList(context, 10, '과제'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 38.h,
                        ),
                        //공지사항
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
                              context.push('/notice_list');
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
                                    '공지사항',
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
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    children: _buildTaskList(context, 10, '공지사항'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 38.h,
                        ),
                        //게시판
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
                              context.push('/post_list');
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
                                    '게시판',
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
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    children: _buildTaskList(context, 10, '게시판'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 38.h,
                        ),
                        Container(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
