import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/bookreport/booksearch_screen_util.dart'
    as searchutil;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MakeLibraryScreen extends StatefulWidget {
  const MakeLibraryScreen({super.key});

  @override
  _MakeLibraryScreenState createState() => _MakeLibraryScreenState();
}

class _MakeLibraryScreenState extends State<MakeLibraryScreen> {
  String _appBarTitle = '서재 이름';
  final TextEditingController _bookTitleController = TextEditingController();
  List<dynamic> BookData = [];
  String _author = "작가";
  String _publisher = "출판사";
  String _isbn = "";
  String _publisherDate = "";
  String _imageUrl = "";
  List<dynamic> _bookList = [];
  Map<String, dynamic> _tempbookList = {};
  var token;

  @override
  void initState() {
    super.initState();

    _initUserState();
  }

  Future<void> _initUserState() async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    token = await secureStorage.readData("token");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(_appBarTitle),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          backgroundColor: const Color(0xFF0E9913),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newName = '';
                    return AlertDialog(
                      title: const Text("서재 이름 입력"),
                      content: TextField(
                        onChanged: (value) {
                          newName = value;
                        },
                        decoration: const InputDecoration(hintText: "새로운 서재"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _appBarTitle = newName;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text("확인"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("취소"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
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
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      //width: _screenWidth * 0.7,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: _bookTitleController,
                        decoration: const InputDecoration(
                          hintText: '도서를 입력하세요.',
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) async {
                          BookData =
                              await SearchBook(_bookTitleController.text);
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('도서 검색 결과'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (int i = 0; i < BookData.length; i++)
                                        searchutil.BookSearchListItem(
                                          data: BookData[i],
                                          type: "search",
                                          clubId: 0,
                                          onSelected: (selectedData) {
                                            print(selectedData);
                                            _tempbookList = {
                                              'isbn': selectedData['isbn'],
                                              'title': selectedData['title'],
                                              'author': selectedData['author'],
                                              'publisher':
                                                  selectedData['publisher'],
                                              'publishDate':
                                                  selectedData['pubdate'],
                                              'imageUrl': selectedData['image'],
                                            };
                                            setState(() {
                                              _bookTitleController.text = "";
                                              _bookList.add(_tempbookList);
                                            });
                                            _tempbookList = {};
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _bookList.length,
                itemBuilder: (context, index) {
                  var book = _bookList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        _bookList.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 105.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3.0),
                              child: Image.network(
                                book['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (book['title'].length > 100)
                                      ? book['title'].substring(0, 100) + '...'
                                      : book['title'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: 'Noto Sans KR',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "${(book['author'] == '') ? '저자 미상' : book['author']} | ${book['publisher']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.sp,
                                    fontFamily: 'Noto Sans KR',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addBooksToLibrary(token, _appBarTitle, _bookList);
            print(_appBarTitle);
            print(_bookList);
            context.pop();
          },
          backgroundColor: const Color(0xFF0E9913),
          child: const Icon(Icons.save),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
