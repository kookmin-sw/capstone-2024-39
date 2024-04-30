import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

//게시글 

bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
}


class PostScreen extends StatefulWidget {
  final String title;
  final String kindOf;
  final String body;

  const PostScreen({
    super.key,
    required this.title,
    required this.kindOf,
    required this.body,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = ['hi', '이미 존재하는 댓글임', '생성 될까?', '나도 모르겠음'];
  // List<String> Real_comments = [];
  

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFF0E9913),
          title: Text(
            widget.kindOf,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
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
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.body,
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
                        title: Text(comments[index]),
                      ),
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
                          borderSide: const BorderSide(color: Color(0xFF0E9913)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      maxLines: null,
                      onChanged: (text) {
                        setState((){});
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color:  _isFieldEmpty(_commentController)? Colors.black:Color(0xFF0E9913),
                    onPressed: () {
                      setState(() {
                        String comment = _commentController.text.trim();
                        if (comment.isNotEmpty) {
                          comments.add(comment);
                          _commentController.clear();
                        }
                        print(comments.length);
                        // sendData();
                        
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