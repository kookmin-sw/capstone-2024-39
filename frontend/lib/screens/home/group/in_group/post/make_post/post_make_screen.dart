import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/bookreport/bookreport_viewing_screen.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/group/group_screen_util.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/http.dart';

class PostMakeScreen extends StatefulWidget {
  final String managerId;
  final int clubId;

  const PostMakeScreen({
    super.key,
    required this.managerId,
    required this.clubId,
  });

  @override
  State<PostMakeScreen> createState() => _PostMakeState();
}

class _PostMakeState extends State<PostMakeScreen> {
  final double _screenWidth = 10;
  bool isSticky = false;
  bool isGroupManager = false;
  var secureStorage;
  var id;
  var token;

  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postbodyController = TextEditingController();

  bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  Future<void> _checkManager() async {
    if (widget.managerId == await secureStorage.readData('id')) {
      isGroupManager = true;
    }
  }

  void disposeController() {
    _postTitleController.dispose();
    _postbodyController.dispose();
  }

  Future<void> _initUserState() async {
    id = await secureStorage.readData('id');
    token = await secureStorage.readData('token');
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);

    setState(() {
      _initUserState();
      _checkManager();
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeController();
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
                  '게시글',
                  style: textStyle(22, Colors.white, true),
                ),
                centerTitle: true,
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_isFieldEmpty(_postTitleController)) {
                        } else if (_isFieldEmpty(_postbodyController)) {
                        } else {
                          String result = await postCreate(
                              token,
                              widget.clubId,
                              _postTitleController.text,
                              _postbodyController.text,
                              isSticky);
                          if (result == '게시글 생성') {
                            context.pop(true);
                          }
                        }
                      },
                      child: Text(
                        '등록',
                        style: textStyle(14, null, false),
                      )),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '제목: ',
                            style: textStyle(15, null, false),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: _screenWidth * 0.7,
                              child: TextField(
                                style: textStyle(14, null, false),
                                controller: _postTitleController,
                                decoration: InputDecoration(
                                  hintText: '제목을 입력하세요.',
                                  hintStyle: textStyle(14, null, false),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: isGroupManager,
                        child: Row(
                          children: [
                            Text(
                              '공지사항',
                              style: textStyle(15, null, false),
                            ),
                            Checkbox(
                              value: isSticky,
                              onChanged: (newValue) {
                                setState(() {
                                  isSticky = !isSticky;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFFA9AFB7),
                          ),
                        ),
                      ),
                      TextField(
                        style: textStyle(14, null, false),
                        controller: _postbodyController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: ' 자유롭게 글을 작성해주세요.',
                          hintStyle: textStyle(14, Colors.grey, false),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

TextStyle textStyle(int fontsize, var color, bool isStroke) {
  return TextStyle(
    fontSize: fontsize.sp,
    fontWeight: (isStroke) ? FontWeight.bold : FontWeight.normal,
    fontFamily: 'Noto Sans KR',
    color: color,
  );
}
