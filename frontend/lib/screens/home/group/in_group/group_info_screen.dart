import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/home/group/in_group/post/post_screen.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/home/group/in_group/groupbook_select_screen.dart';

//그룹 상세 페이지

//회원가입, 모임 나가기, 동적 멤버 리스트, 추방, 임명 - 완
//미로그인시(토큰이 없을시) 회원 가입 눌렀을 때 알림창이 뜨도록 구현하기

class GroupInfoScreen extends StatefulWidget {
  final int clubId;
  final String groupName;

  const GroupInfoScreen({
    super.key,
    required this.clubId,
    required this.groupName,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfoScreen> {
  // loading 관리
  bool _isLoading = true;
  //drawer 상태관리
  bool _isDrawerOpen = false;
  //그룹의 모임원 여부
  bool _isGroupMember = false;
  //그룹의 모임장 여부
  bool _isGroupManager = false;
  //그룹원(모임원, 모임장)이 설정을 누른지 확인
  bool _isManage = false;
  //모임장의 기능 확인 (true - 추방, flase - 권한 위임)
  bool _isKicked = false;
  // 멤버들의 체크 상태를 저장하는 리스트
  List<bool> _memberCheckStates = [];
  // 멤버 목록
  List<String> _member = [];
  List<String> _memberId = [];
  // 체크박스 타켓 인덱스
  int _targetIndex = 0;
  // 기본 환경변수
  var id; // 유저 uuid
  var token; // 유저 token
  var clubData; // 현재 모임의 데이터
  var userdata; // 유저 정보
  var clubHwList; // 그룹의 과제 리스트

  //그룹 멤버인지 확인
  Future<bool> userState(var id, var token) async {
    if (id == null || token == null) {
      return false;
    }
    userdata = await getUserInfo(id, token);
    for (int i = 0; i < userdata['clubsList'].length; i++) {
      if (userdata['clubsList'][i]['clubId'] == widget.clubId) {
        return true;
      }
    }
    return false;
  }

  // 모임원 한명씩 생성
  Widget _generateMember(String memName, int index) {
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
      updateGroupList();
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
                Text(
                  userdata['name'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
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
                          String result = await groupOut(token, widget.clubId);
                          if (result == "모임 탈퇴 완료") {
                            _isGroupMember = false;
                            await _clubGetInfo();
                            await _clubGetAssign();
                          }
                        }
                      }
                    },
                    icon: _isGroupManager
                        ? const Icon(Icons.settings)
                        : const Icon(Icons.logout)),
              ],
            ),
          ),
          // 모임원 리스트 생성(list <Widget>)
          for (int i = 0; i < _member.length; i++)
            _generateMember(_member[i], i),

          // 모임원의 상태 적용 - 모임장만 보이도록
          Visibility(
            visible: _isManage && _isGroupManager,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  bool result =
                      await _showLastConfirmationDialog(context, _isKicked);
                  for (int i = 0; i < _memberCheckStates.length; i++) {
                    if (_memberCheckStates[i]) {
                      _targetIndex = i;
                      break;
                    }
                  }
                  String target = _memberId[_targetIndex];
                  // 추방할 때
                  if (_isKicked) {
                    if (result) {
                      //추방 O
                      String response =
                          await groupExpel(token, target, clubData['id']);
                      if (response == "추방 완료") {
                        await _clubGetInfo();
                        await _clubGetAssign();
                        updateGroupList();
                      }
                    } else {
                      //추방 취소
                    }
                  }
                  // 모임장 위임할 때
                  else {
                    if (result) {
                      String response =
                          await groupDelegate(token, target, clubData['id']);
                      if (response == "위임 완료") {
                        await _clubGetInfo();
                        await _clubGetAssign();
                        updateGroupList();
                        setState(() {
                          _isGroupManager = false;
                        });
                      }
                    } else {}
                  }
                  // 원래대로 초기화
                  setState(() {
                    _isKicked = false;
                    _isManage = false;
                  });
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
              title: Text("마지막으로 확인하겠습니다"),
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
                      updateGroupList();
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
                      updateGroupList();
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
  Future<bool> _showLastConfirmationDialog(
      BuildContext context, bool kickState) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("마지막으로 확인하겠습니다"),
              content: (kickState) ? Text("추방하시겠습니까?") : Text("임명하시겠습니까?"),
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

  // 제한인원 초과 경우
  void _showMaxlimitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('가입 실패'),
          content: Text('모임의 정원이 초과되었습니다.'),
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

  // 로그인을 안한 경우
  void _showLoginlimitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('가입 실패'),
          content: Text('로그인이 필요한 기능입니다.'),
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

  final TextEditingController _textControllers = TextEditingController();

  bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  @override
  void dispose() {
    _textControllers.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initUserState();
    _loadData();
  }

  Future<void> _loadData() async {
    // 일정 시간이 지난 후에 로딩 상태를 변경하여 화면을 업데이트
    Timer(Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _clubGetInfo() async {
    clubData = await groupSerachforId(widget.clubId);

    setState(() {});
    // print(clubData);
  }

  Future<void> _clubGetAssign() async {
    clubHwList = await getAssign(token, widget.clubId);
    setState(() {});
  }

  // // _memberCheckStates 초기화
  void _initializeMemberCheckStates() {
    _memberCheckStates = List.filled(clubData['memberList'].length, false);
  }

  void _memberinitialize() {
    setState(() {
      _member = [];
      _memberId = [];
      for (var member in clubData['memberList']) {
        if (member['id'] == id) {
          continue;
        }
        _member.add(member['name']);
        _memberId.add(member['id']);
      }
    });
  }

  void updateGroupList() {
    _initializeMemberCheckStates();
    _memberinitialize();
  }

  Future<void> _initUserState() async {
    try {
      final secureStorage =
          Provider.of<SecureStorageService>(context, listen: false);
      bool isGroupManager = false;
      id = await secureStorage.readData("id");
      token = await secureStorage.readData("token");
      bool isGroupMember = await userState(id, token);
      await _clubGetInfo();
      await _clubGetAssign();

      if (id == clubData['managerId']) {
        isGroupManager = true;
      }

      setState(() {
        _textControllers.clear();
        _isGroupMember = isGroupMember;
        _isGroupManager = isGroupManager;
        updateGroupList();
        // print(clubData['book']);
      });
    } catch (e) {
      setState(() {
        _isGroupMember = false;
        _isGroupManager = false;
        updateGroupList();
      });
    }
  }

  Widget _searchWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          padding: EdgeInsets.only(left: 10.w),
          height: 40.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_isFieldEmpty(_textControllers)) {
                    // 검색 x
                    // BookData = [];
                  } else {
                    context.push('/groupbook_select', extra: {
                      "title": _textControllers.text,
                      "clubId": clubData['id'],
                    }).then((result) async {
                      if (result == true) {
                        await _clubGetInfo();
                        await _clubGetAssign();
                        setState(() {
                          // print(clubData['book']);
                        });
                      }
                    });
                    _textControllers.clear();
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.search),
              ),
              SizedBox(
                width: 260.w,
                child: TextField(
                  controller: _textControllers,
                  decoration: const InputDecoration(
                    hintText: '대표책을 검색해주세요.',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    if (_isFieldEmpty(_textControllers)) {
                      // 검색 x
                      // BookData = [];
                    } else {
                      context.push('/groupbook_select', extra: {
                        "title": _textControllers.text,
                        "clubId": clubData['id'],
                      }).then((result) async {
                        if (result == true) {
                          await _clubGetInfo();
                          await _clubGetAssign();
                          setState(() {
                            // print(clubData['book']);
                          });
                        }
                      });
                      _textControllers.clear();
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bookWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
          child: Column(
            children: [
              Text(
                '대표책',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 80.w,
                height: 105.h,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(clubData['book']['imageUrl']),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Column(
            children: [
              SizedBox(
                width: 250.w,
                child: Text(
                  clubData['book']['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 250.w,
                child: Text(
                  "${(clubData['book']['author'].length != 0) ? clubData['book']['author'] : '저자 미상'} | ${clubData['book']['publisher']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // 로딩 애니매이션
            )
          : Scaffold(
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
                          onTap: () async {
                            if (id == null || token == null) {
                              _showLoginlimitDialog();
                            } else if (clubData['maximum'] ==
                                clubData['memberCnt']) {
                              _showMaxlimitDialog();
                            } else {
                              // 회원 가입 동작
                              String result =
                                  await groupJoin(token, widget.clubId);
                              await _clubGetInfo();
                              await _clubGetAssign();
                              if (result == "모임 가입 완료") {
                                setState(() {
                                  _isGroupMember = true;
                                  updateGroupList();
                                });
                              }
                            }
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
              endDrawer: (_isGroupMember) ? _buildGroupList(context) : null,
              onEndDrawerChanged: _handleDrawerStateChanged,
              body: Center(
                child: Column(
                  children: [
                    Container(
                      height: (_isGroupManager)
                          ? (clubData["book"] == null)
                              ? 80.h
                              : 220.h
                          : (clubData["book"] == null)
                              ? 20.h
                              : 160.h,
                      width: 390.w,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF0E9913),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                      child: Container(
                          child: (_isGroupManager)
                              ? (clubData["book"] != null)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _bookWidget(),
                                        _searchWidget(),
                                      ],
                                    )
                                  : _searchWidget()
                              : (clubData["book"] != null)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _bookWidget(),
                                      ],
                                    )
                                  : null),
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
                                  if (_isGroupMember) {
                                    context.push('/homework_list', extra: {
                                      "clubId": clubData['id'],
                                      "managerId": clubData['managerId'],
                                    }).then((value) async {
                                      await _clubGetInfo();
                                      await _clubGetAssign();
                                    });
                                  }
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
                                        children: _buildTaskList(context, '과제'),
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
                                  if (_isGroupMember) {
                                    context.push('/notice_list', extra: {
                                      "clubId": clubData['id'],
                                      "managerId": clubData['managerId'],
                                    }).then((value) async {
                                      await _clubGetInfo();
                                      await _clubGetAssign();
                                    });
                                  }
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
                                        children:
                                            _buildTaskList(context, '공지사항'),
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
                                  if (_isGroupMember) {
                                    context.push('/post_list', extra: {
                                      "clubId": clubData['id'],
                                      "managerId": clubData['managerId'],
                                    }).then((value) async {
                                      await _clubGetInfo();
                                      await _clubGetAssign();
                                    });
                                  }
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
                                        children:
                                            _buildTaskList(context, '게시판'),
                                      ),
                                    ),
                                  ],
                                ),
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

  //각 게시판의 글들을 리스트로 형성
  List<Widget> _buildTaskList(BuildContext context, String type) {
    List<Widget> tasks = [];
    List<dynamic> temp;
    int cnt = 0;
    switch (type) {
      case '게시판':
        temp = clubData['posts'];
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["createdAt"]);
          DateTime dateTimeB = DateTime.parse(b["createdAt"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 3) {
            break;
          }
          cnt++;
          tasks.add(_buildTaskEntry(context, post, true));
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
        break;
      case '공지사항':
        temp = clubData['posts'];
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["createdAt"]);
          DateTime dateTimeB = DateTime.parse(b["createdAt"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (post['isSticky'] == true) {
            if (cnt > 3) {
              break;
            }
            cnt++;
            tasks.add(_buildTaskEntry(context, post, true));
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
        }
        break;
      case '과제':
        if (clubHwList == null) {
          break;
        }
        temp = clubHwList;
        temp.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a["endDate"]);
          DateTime dateTimeB = DateTime.parse(b["endDate"]);
          return dateTimeB.compareTo(dateTimeA);
        });
        for (var post in temp) {
          if (cnt > 3) {
            break;
          }
          cnt++;
          tasks.add(_buildTaskEntry(context, post, false));
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
        break;
      default:
        break;
    }

    return tasks;
  }

  //각 게시판의 최신글
  Widget _buildTaskEntry(BuildContext context, var post, bool isPost) {
    return InkWell(
      onTap: () {
        //글 목록 탭 됐을 때
        if (isPost) {
          if (_isGroupMember) {
            context.push('/post', extra: {
              'postId': post['id'],
              'clubId': post['clubId'],
            }).then((value) async {
              await _clubGetInfo();
              await _clubGetAssign();
            });
          }
        }
        //과제가 탭 됐을 때
        else {
          if (_isGroupMember) {
            context.push('/homeworkmember_make', extra: {
              'post': post,
              'clubId': widget.clubId,
            }).then((value) async {
              await _clubGetInfo();
              await _clubGetAssign();
            });
          }
        }
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
            (isPost) ? post['title'] : post['name'],
          ),
        ),
      ),
    );
  }
}
