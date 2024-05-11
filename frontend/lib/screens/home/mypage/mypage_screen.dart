import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MypageScreenState createState() => _MypageScreenState();
}

class Book {
  final String title;
  final String author;
  final String publisher;
  final String startDate;
  final String endDate;
  final String type;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.publisher,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.imageUrl,
  });

  //   factory Book.fromJson(Map<String, dynamic> json) {
  //   return Book(
  //     id: json['id'] as int,
  //     writer: json['writer'] as String,
  //     clubId: json['clubId'] as int,
  //     title: json['title'] as String,
  //     body: json['body'] as String,
  //     isSticky: json['isSticky'] as bool,
  //   );
  // }
}

class Library {
  String name;
  List<LibraryBook> books;

  Library({required this.name, required this.books});
}

class LibraryBook {
  String title;
  String author;
  String publisher;
  String imageUrl;

  LibraryBook(
      {required this.title,
      required this.author,
      required this.publisher,
      required this.imageUrl});
}

class _MypageScreenState extends State<MypageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Book> books = [];

  List<Library> libraries = [
    Library(
      name: '즐겨찾기',
      books: [
        LibraryBook(
          title: '원씽',
          author: 'Gary Keller, Jay Papasan',
          publisher: 'Business Books',
          imageUrl: 'https://via.placeholder.com/70x100',
        ),
        LibraryBook(
          title: '원씽2',
          author: 'Gary Keller, Jay Papasan',
          publisher: 'Business Books',
          imageUrl: 'https://via.placeholder.com/70x100',
        ),
        LibraryBook(
          title: '원씽',
          author: 'Gary Keller, Jay Papasan',
          publisher: 'Business Books',
          imageUrl: 'https://via.placeholder.com/70x100',
        ),
        LibraryBook(
          title: '원씽2',
          author: 'Gary Keller, Jay Papasan',
          publisher: 'Business Books',
          imageUrl: 'https://via.placeholder.com/70x100',
        ),
      ],
    ),
    Library(
      name: '읽고 싶은 책',
      books: [
        LibraryBook(
          title: '원씽(The One Thing)',
          author: 'Gary Keller, Jay Papasan',
          publisher: 'Business Books',
          imageUrl: 'https://via.placeholder.com/70x100',
        ),
        LibraryBook(
          title: '원씽(The One Thing)2',
          author: 'Gary Keller, Jay Papasan',
          publisher: 'Business Books',
          imageUrl: 'https://via.placeholder.com/70x100',
        ),
      ],
    ),
  ];

  var id;
  var token;
  var isLogin;

  @override
  void initState() {
    super.initState();
    _initUserState();
    // _initBookState();
    _tabController = TabController(length: 2, vsync: this);
    books.sort((a, b) => a.endDate.compareTo(b.endDate));
  }

  Future<void> _initUserState() async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    token = await secureStorage.readData("token");
    print(token);
    if (token == null) {
      isLogin = false;
    } else {
      isLogin = true;
    }
  }

// Future<void> _initBookState() async {
//   final secureStorage =
//       Provider.of<SecureStorageService>(context, listen: false);
//   id = await secureStorage.readData("id");
//   token = await secureStorage.readData("token");
//   Map<String, dynamic> userInfo = await getUserInfo(id, token);
//   if (userInfo.containsKey("contentList")) {
//     books = List<Book>.from(userInfo["contentList"].map((bookJson) => Book.fromJson(bookJson)));
//   } else {
//     books = []; // Handle case when "postList" is not present or is empty
//   }
// }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('마이페이지'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          backgroundColor: const Color(0xFF0E9913),
          centerTitle: true,
        ),
        body: Column(
          children: [
            if (isLogin == true) const LoggedWidget() else const LoginWidget(),
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
                  MyLibraryWidget(libraries: libraries),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoggedWidget extends StatelessWidget {
  const LoggedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Provider.of<SecureStorageService>(context, listen: false)
          .readData("name"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final name = snapshot.data ?? '';
          return Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 16.w),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 65.w),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
                  //context.push('/login');
                  signInWithGoogle(context);
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
}

void signInWithGoogle(BuildContext context) async {
  final secureStorage =
      Provider.of<SecureStorageService>(context, listen: false);
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser != null) {
    // print('name = ${googleUser.displayName}');
    // print('email = ${googleUser.email}');
    // print('id = ${googleUser.id}');
    dynamic userInfo = await login(googleUser.email);
    await secureStorage.saveData('userID', googleUser.email);
    if (userInfo['token'] == null) {
      context.push('/signup');
    }
    print(userInfo['token']);
    print(userInfo['id']);
    await secureStorage.saveData("token", userInfo['token']);
    await secureStorage.saveData("id", userInfo['id']);
  }
}

class BookReportWidget extends StatelessWidget {
  final List<Book> books;

  const BookReportWidget({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () async {
            context.push('/bookreport_viewing');
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
                      '${book.startDate} ~ ${book.endDate}',
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
                      book.type,
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
                      '${book.author} | ${book.publisher}',
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
                      book.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                      ),
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
                        image: NetworkImage(book.imageUrl),
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

class MyLibraryWidget extends StatelessWidget {
  final List<Library> libraries;

  const MyLibraryWidget({super.key, required this.libraries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: libraries.length,
        itemBuilder: (context, index) {
          var library = libraries[index];
          return Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  library.name,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  height: 154.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: library.books.length,
                    itemBuilder: (context, bookIndex) {
                      var book = library.books[bookIndex];
                      return Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 90.w,
                              height: 128.52.h,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(book.imageUrl),
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: 90.w,
                              height: 20.h,
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
          context.push('/make_library');
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
