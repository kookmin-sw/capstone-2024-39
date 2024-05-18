import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';

//책의 컨텐츠 목록

class BookContentScreen extends StatefulWidget {
  final dynamic posts;
  final String type;
  final String isbn;

  const BookContentScreen({
    super.key,
    required this.posts,
    required this.type,
    required this.isbn,
  });

  @override
  State<BookContentScreen> createState() => _BookContentState();
}

class _BookContentState extends State<BookContentScreen> {
  List<dynamic> posts = [];
  var secureStorage;
  var id;
  var token;

  Future<void> initUserInfo() async {
    var _id = await secureStorage.readData("id");
    var _token = await secureStorage.readData("token");
    setState(() {
      id = _id;
      token = _token;
      print(id);
    });
  }

  Future<void> updatePostList() async {
    var _posts;
    if (widget.type == "Quiz") {
      _posts = await bookQuizLoad(widget.isbn);
    } else {
      _posts = await bookcontentLoad(widget.isbn, widget.type);
    }
    if (_posts.runtimeType == Map<String, dynamic>) {
      _posts = [];
    }
    setState(() {
      posts = _posts;
    });
  }

  int typeCheck(String types) {
    switch (types) {
      case "Review":
        return 996;
      case "ShortReview":
        return 997;
      case "Quotation":
        return 998;
      case "Quiz":
        return 999;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    initUserInfo();
    setState(() {
      posts = widget.posts;
    });
    // updatePostList();
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
            widget.type,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: (id != null && token != null)?FloatingActionButton(
          onPressed: () {
            context.push(
              '/bookreport_writing',
              extra: {
                "index": typeCheck(widget.type),
                "clubId": null,
                "asId": null,
                "isbn": widget.isbn,
                "dateInfo":null,
              },
            ).then((result) async {
              updatePostList();
            });
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ):null,
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(posts),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPostListView(List<dynamic> posts) {
    List<Widget> items = [];

    for (Map<String, dynamic> post in posts) {
      items.add(
        Column(
          children: [
            SizedBox(
              height: 58.h,
              width: double.infinity,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    context.push(
                      '/bookreport_viewing',
                      extra: post,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (widget.type == "Quiz")
                          ? post['description']
                          : post['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return items;
  }
}
