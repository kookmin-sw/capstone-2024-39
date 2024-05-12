import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
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
                title: const Text(
                  '게시글',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: ()async {
                        if(_isFieldEmpty(_postTitleController)){

                        }
                        else if(_isFieldEmpty(_postbodyController)){

                        }
                        else{
                          String result = await postCreate(
                            token,
                            widget.clubId,
                            _postTitleController.text,
                            _postbodyController.text,
                            isSticky);
                          if(result == '게시글 생성'){
                            context.pop(true);
                          }
                        }
                        
                      },
                      child: const Text('등록')),
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
                          const Text('제목: '),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: _screenWidth * 0.7,
                              child: TextField(
                                style: const TextStyle(fontSize: 14),
                                controller: _postTitleController,
                                decoration: const InputDecoration(
                                  hintText: '제목을 입력하세요.',
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
                            const Text('공지사항'),
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
                        style: const TextStyle(fontSize: 14),
                        controller: _postbodyController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: ' 자유롭게 글을 작성해주세요.',
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
