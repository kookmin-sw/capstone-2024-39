import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'dart:async';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

//글

bool _isFieldEmpty(TextEditingController controller) {
  return controller.text.trim().isEmpty;
}

List<dynamic> comments = [];
var token;
var id;
var data;

class PostScreen extends StatefulWidget {
  // final String title;
  // final bool kindOf;
  // final String body;
  // final List<dynamic> comments;
  final int postId;
  final int clubId;
  // final Map<String, dynamic> data;

  const PostScreen({
    super.key,
    // required this.title,
    // required this.kindOf,
    // required this.body,
    // required this.comments,
    required this.postId,
    required this.clubId,
    // required this.data,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPostState();
    _loadData();
  }

  Future<void> _loadData() async {
    // 일정 시간이 지난 후에 로딩 상태를 변경하여 화면을 업데이트
    Timer(Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _initPostState() async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    id = await secureStorage.readData("id");
    token = await secureStorage.readData("token");

    var tempdata = await getPost(token, widget.postId, widget.clubId);

    setState(() {
      data = tempdata;
      comments = data['commentResponseList'];
    });
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
            (data['isSticky']) ? "공지사항" : "게시글",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(), // 로딩 애니매이션
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //본문 내용 + 댓글창
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data['body'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 댓글창
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                                title: Text(comments[index]['writer']),
                                subtitle: Text(comments[index]['body'])),
                            const Divider(
                              height: 2, // 선의 높이를 조절할 수 있습니다.
                              thickness: 0.2, // 선의 두께를 조절할 수 있습니다.
                              color: Colors.grey, // 선의 색상을 설정할 수 있습니다.
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  //댓글 입력창
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 30,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: ' 댓글을 입력하세요...',
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Color(0xFF0E9913)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.blueGrey),
                              ),
                            ),
                            maxLines: null,
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: _isFieldEmpty(_commentController)
                              ? Colors.black
                              : Color(0xFF0E9913),
                          onPressed: () async {
                            String comment = _commentController.text.trim();
                            if (comment.isNotEmpty) {
                              await commentCreate(token, data['id'], comment);
                              data = await getPost(
                                  token, widget.postId, widget.clubId);
                              _commentController.clear();
                            }
                            setState(() {
                              comments = data['commentResponseList'];
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
