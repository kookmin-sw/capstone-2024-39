import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/bookreport/booksearch_screen_util.dart'
    as searchutil;
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  _MypageScreenState createState() => _MypageScreenState();
}

class Library {
  String name;
  List<LibraryBook> books;

  Library({required this.name, required this.books});
}

class LibraryBook {
  String title;
  String author;
  //String description;
  String publisher;
  //String publishDate;
  String isbn;
  String imageUrl;

  LibraryBook({
    required this.title,
    required this.author,
    //required this.description,
    required this.publisher,
    //required this.publishDate,
    required this.isbn,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      //'description': description,
      'publisher': publisher,
      //'publishDate': publishDate,
      'isbn': isbn,
      'imageUrl': imageUrl,
    };
  }
}

class _MypageScreenState extends State<MypageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<dynamic> books = [];
  List<Library> libraries = [];

  String? id;
  String? token;
  String? name;
  String? age;
  String? gender;
  bool isLogin = false;
  dynamic userInfo;
  int? userId;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initUserState();
    _loadData(500);
  }

  Future<void> _loadData(int term) async {
    Timer(Duration(milliseconds: term), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _initUserState() async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    token = await secureStorage.readData("token");
    id = await secureStorage.readData("id");

    if (token == null) {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
      userInfo = await getUserInfo(id!, token!);
      setState(() {
        name = userInfo['name'];
        age = userInfo['age']?.toString() ?? '0';
        gender = userInfo['gender'];
        books = userInfo['contentList'];
        print(books);
        secureStorage.saveData('name', name!);
        secureStorage.saveData('age', age!);
        secureStorage.saveData('gender', gender!);
      });
      await _fetchLibraries(token!);
    }
  }

  Future<void> _fetchLibraries(String token) async {
    final fetchedLibraries = await getLibrary(token);
    setState(() {
      libraries = parseLibraries(fetchedLibraries);
    });
  }

  List<Library> parseLibraries(List<dynamic> libraryData) {
    // Create a map of library names to Library objects
    Map<String, Library> libraryMap = {};

    for (var entry in libraryData) {
      final groupName = entry['groupName'];
      final book = LibraryBook(
        title: entry['title'],
        author: entry['author'],
        //description: entry['description'],
        publisher: entry['publisher'],
        //publishDate: entry['publishDate'],
        isbn: entry['isbn'],
        imageUrl: entry['imageUrl'],
      );

      if (libraryMap.containsKey(groupName)) {
        libraryMap[groupName]!.books.add(book);
      } else {
        libraryMap[groupName] = Library(name: groupName, books: [book]);
      }
    }
    return libraryMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('마이페이지'),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
          backgroundColor: const Color(0xFF0E9913),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.h),
                  child: const CircularProgressIndicator(),
                ), // 로딩 애니매이션
              )
            : Column(
                children: [
                  if (isLogin)
                    LoggedWidget(
                      name: name ?? '이름 없음',
                      age: age ?? '0',
                      gender: gender ?? '성별 없음',
                      updateLoginStatus: _updateLoginStatus,
                    )
                  else
                    LoginWidget(updateLoginStatus: _updateLoginStatus),
                  TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: const Color(0xFF6E767F),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    controller: _tabController,
                    tabs: const [
                      Tab(text: '독후감'),
                      Tab(text: '나만의 서재'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BookReportWidget(books: books),
                        MyLibraryWidget(
                          libraries: libraries,
                          onLibraryUpdated: _initUserState,
                          token: token ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _updateLoginStatus(bool isLoggedIn) {
    setState(() {
      isLogin = isLoggedIn;
      if (!isLoggedIn) {
        books = [];
        libraries = [];
      }
      _initUserState();
    });
  }
}

class LoggedWidget extends StatefulWidget {
  final void Function(bool isLogin) updateLoginStatus;
  final String name;
  final String age;
  final String gender;

  const LoggedWidget({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.updateLoginStatus,
  });

  @override
  _LoggedWidgetState createState() => _LoggedWidgetState();
}

class _LoggedWidgetState extends State<LoggedWidget> {
  @override
  Widget build(BuildContext context) {
    String genderKR = "";
    if (widget.gender == "MALE") {
      genderKR = "남성";
    } else if (widget.gender == "FEMALE") {
      genderKR = "여성";
    }

    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_circle,
            size: 70.w,
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.age}세',
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                genderKR,
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final secureStorage =
                  Provider.of<SecureStorageService>(context, listen: false);
              await secureStorage.deleteData("token");
              await secureStorage.deleteData("id");
              await secureStorage.deleteData("name");
              await secureStorage.deleteData("age");
              await secureStorage.deleteData("gender");
              widget.updateLoginStatus(false);
            },
            child: const Text('로그아웃'),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  final void Function(bool isLogin) updateLoginStatus;

  const LoginWidget({super.key, required this.updateLoginStatus});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  dynamic userInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 20.w),
              SizedBox(
                width: 140.w,
                height: 37.h,
                child: Text(
                  '로그인하고 독후감을 작성해보세요!',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(width: 76.w),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    signInWithGoogle(context);
                  });
                },
                child: const Text('로그인'),
              ),
            ],
          ),
          SizedBox(height: 15.w),
        ],
      ),
    );
  }

  void signInWithGoogle(BuildContext context) async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print(googleUser);

    if (googleUser != null) {
      userInfo = await login(googleUser.email);
      await secureStorage.saveData('userID', googleUser.email);
      print('로그인');
      if (userInfo['exceptionCode'] != null) {
        context.push('/signup').then((_) {
          setState(() {
            widget.updateLoginStatus(true);
            //여기서 유저정보 업데이트 관련 함수 실행 필요
          });
        });
      } else {
        await secureStorage.saveData("token", userInfo['token']);
        await secureStorage.saveData("id", userInfo['id']);
        widget.updateLoginStatus(true);
      }
    }
  }
}

class BookReportWidget extends StatelessWidget {
  final List<dynamic> books;

  const BookReportWidget({super.key, required this.books});

  String setTemplateType(String type) {
    if (type == 'Review') {
      return '독후감';
    } else if (type == 'ShortReview') {
      return '한줄평';
    } else if (type == 'Quotation') {
      return '인용구';
    } else {
      return '퀴즈';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final startDate = book['startDate'].toString().substring(0, 10);
        final endDate = book['endDate'].toString().substring(0, 10);
        return GestureDetector(
          onTap: () async {
            context.push('/bookreport_viewing', extra: book);
          },
          child: SizedBox(
            height: 101.h,
            child: Stack(
              children: [
                Positioned(
                  left: 90.w,
                  top: 75.h,
                  child: SizedBox(
                    width: 240.w,
                    height: 16.h,
                    child: Text(
                      '$startDate ~ $endDate',
                      style: TextStyle(
                        color: const Color(0xFF6E767F),
                        fontSize: 9.sp,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 90.w,
                  top: 60.h,
                  child: SizedBox(
                    width: 240.w,
                    height: 45.h,
                    child: Text(
                      setTemplateType(book['type']),
                      style: TextStyle(
                        color: const Color(0xFF6E767F),
                        fontSize: 9.sp,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 90.w,
                  top: 43.h,
                  child: SizedBox(
                    width: 240.w,
                    height: 16.h,
                    child: Text(
                      '${book['book']['author']} | ${book['book']['publisher']}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 90.w,
                  top: 15.h,
                  child: SizedBox(
                    width: 240.w,
                    child: Text(
                      book['title'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  left: 15.w,
                  top: 15.h,
                  child: Container(
                    width: 60.w,
                    height: 85.68.h,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(book['book']['imageUrl']),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyLibraryWidget extends StatefulWidget {
  final List<Library> libraries;
  final VoidCallback onLibraryUpdated;
  final String token;

  const MyLibraryWidget({
    super.key,
    required this.libraries,
    required this.onLibraryUpdated,
    required this.token,
  });

  @override
  _MyLibraryWidgetState createState() => _MyLibraryWidgetState();
}

class _MyLibraryWidgetState extends State<MyLibraryWidget> {
  List<dynamic> BookData = [];
  final TextEditingController _bookTitleController = TextEditingController();

  Future<void> _searchBookAndSetState(StateSetter updateState) async {
    BookData = await SearchBook(_bookTitleController.text);
    updateState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.libraries.length,
        itemBuilder: (context, index) {
          var library = widget.libraries[index];
          return Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      library.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (String result) async {
                        if (result == 'edit') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${library.name}의 책 목록'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: library.books.length,
                                    itemBuilder:
                                        (BuildContext context, int bookIndex) {
                                      var book = library.books[bookIndex];
                                      return ClipRect(
                                        child: Dismissible(
                                          key: Key(book.title.toString()),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (direction) {
                                            setState(() {
                                              deleteBookFromLibrary(
                                                  widget.token,
                                                  library.name,
                                                  book.isbn);
                                              widget.onLibraryUpdated();
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '${library.name}에서 ${book.title} 삭제됨')),
                                            );
                                          },
                                          background: Container(
                                            color: Colors.red,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.h),
                                            child: const Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                          child: ListTile(
                                            title: Text(book.title),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('닫기'),
                                    onPressed: () {
                                      widget.onLibraryUpdated();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (result == 'delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${library.name} 삭제'),
                                content: const Text('정말 삭제하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('삭제'),
                                    onPressed: () {
                                      deleteLibrary(widget.token, library.name);
                                      widget.onLibraryUpdated();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          print('Delete ${library.name}');
                        } else if (result == 'add') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              BookData = [];
                              _bookTitleController.clear();
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text('책 추가하기'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5.h, left: 5.w, right: 5.w),
                                          padding: EdgeInsets.only(left: 5.w),
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.search),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: SizedBox(
                                                  child: TextField(
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    controller:
                                                        _bookTitleController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: '도서를 입력하세요.',
                                                      border: InputBorder.none,
                                                    ),
                                                    textInputAction:
                                                        TextInputAction.go,
                                                    onSubmitted: (value) async {
                                                      await _searchBookAndSetState(
                                                          setState);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                for (int i = 0;
                                                    i < BookData.length;
                                                    i++)
                                                  searchutil.BookSearchListItem(
                                                    data: BookData[i],
                                                    type: "search",
                                                    clubId: 0,
                                                    onSelected:
                                                        (selectedData) async {
                                                      print(selectedData);
                                                      _bookTitleController
                                                          .clear();
                                                      await addBookToLibrary(
                                                        widget.token,
                                                        selectedData['isbn'],
                                                        selectedData['title'],
                                                        selectedData[
                                                            'description'],
                                                        selectedData['author'],
                                                        selectedData[
                                                            'publisher'],
                                                        selectedData['pubdate'],
                                                        selectedData['image'],
                                                        library.name,
                                                      );
                                                      widget.onLibraryUpdated();
                                                      setState(() {
                                                        BookData = [];
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('수정하기'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('삭제하기'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'add',
                          child: Text('추가하기'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  height: 154.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: library.books.length,
                    itemBuilder: (context, bookIndex) {
                      var book = library.books[bookIndex];
                      print(book.toMap());
                      return GestureDetector(
                        onTap: () {
                          //context.push('/book_info', extra: book.toMap());
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 90.w,
                                height: 128.52.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(book.imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: 90,
                                height: 20,
                                child: Text(
                                  book.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/make_library').then((_) {
            widget.onLibraryUpdated();
          });
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
