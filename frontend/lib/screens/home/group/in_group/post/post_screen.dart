import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  final int postId;
  final int clubId;

  const PostScreen({
    super.key,
    required this.postId,
    required this.clubId,
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
      print(data);
    });
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
              appBar: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: const Color(0xFF0E9913),
                title: Text(
                  (data['isSticky']) ? "공지사항" : "게시글",
                  style: textStyle(22, Colors.white, true),
                ),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //본문 내용 + 댓글창
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(13.w),
                            child: Text(data['title'], style: textStyle(23, null, false)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left:13.w, bottom: 5.h),
                            child: Text("작성자 ${data['writer']}",style: textStyle(15, null, false),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left:13.w, bottom: 5.h),
                            child: Text(formatDate(data['createdAt']), style: textStyle(12, Colors.grey, false)),
                          ),
                          Divider(
                            height: 1.h,
                            thickness: 0.2,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 5.h),
                          Padding(
                            padding: EdgeInsets.all(14.w),
                            child: Text(
                              data['body'],
                              style: textStyle(16, null, false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 댓글창
                  Divider(
                    height: 1.h,
                    thickness: 0.2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "댓글 ${comments.length}",
                      style: textStyle(16, null, false),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(comments[index]['writer']),
                              titleTextStyle: textStyle(16, Colors.black, true),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Text(comments[index]['body']),
                              ),
                              subtitleTextStyle:
                                  textStyle(16, Colors.black, false),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, bottom: 8.h),
                              child: Text(
                                formatDate(comments[index]['createdAt']),
                                style: textStyle(12, Colors.grey, false),
                              ),
                            ),
                            Divider(
                              height: 1.h,
                              thickness: 0.2,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  //댓글 입력창
                  Container(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 8.h,
                      bottom: 30.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 350.w,
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: ' 댓글을 입력하세요...',
                                hintStyle: textStyle(17, Colors.grey, false),
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF0E9913)),
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

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('yyyy.MM.dd. HH:mm').format(dateTime);
  return formattedDate;
}

TextStyle textStyle(int fontsize, var color, bool isStroke) {
  return TextStyle(
    fontSize: fontsize.sp,
    fontWeight: (isStroke) ? FontWeight.bold : FontWeight.normal,
    fontFamily: 'Noto Sans KR',
    color: color,
  );
}
