import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//게시글 

bool _isFieldEmpty(TextEditingController controller) {
    return controller.text.trim().isEmpty;
}


String token = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjNmMDZhZjYzLWE5M2MtMTFlNC05Nzk3LTAwNTA1NjkwNzczZiIsImlhdCI6MTcxMzk0MTc3MSwiZXhwIjoxNzE0MDI4MTcxfQ.GObwbwgld7cE0GC6ixYO_7rhS_u571TXuGmwT-nET-ZjADhYT2ADVuAi3KD4AXYYFqHqBuy4ymx66hl5k49zVQ";

Future<String> sendData() async {
  //http.post는 리턴값이 Future이기 떄문에 async 함수 내에서 await로 호출할 수 있다.
var test = Uri.parse('http://ec2-15-165-85-185.ap-northeast-2.compute.amazonaws.com:8080/comment/1');
  http.Response res = await http.get(
    test,
    headers: {"Content-Type":"application/json",
      'Authorization': 'Bearer $token'
    },
    // body: json.encode({
    //   "email" : "example1@gmail.com",
    //   "token" : "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjNmMDZhZjYzLWE5M2MtMTFlNC05Nzk3LTAwNTA1NjkwNzczZiIsImlhdCI6MTcxMzk0MTc3MSwiZXhwIjoxNzE0MDI4MTcxfQ.GObwbwgld7cE0GC6ixYO_7rhS_u571TXuGmwT-nET-ZjADhYT2ADVuAi3KD4AXYYFqHqBuy4ymx66hl5k49zVQ",
    // })
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  final comment = data['body'];
  print(comment);
  // print(res.body);
  //여기서는 응답이 객체로 변환된 res 변수를 사용할 수 있다.
  //여기서 res.body를 jsonDecode 함수로 객체로 만들어서 데이터를 처리할 수 있다.

  return res.body; //작업이 끝났기 때문에 리턴
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