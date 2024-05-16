import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

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
  String publisher;
  String imageUrl;

  LibraryBook({
    required this.title,
    required this.author,
    required this.publisher,
    required this.imageUrl,
  });
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initUserState();
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
        publisher: entry['publisher'],
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
            if (isLogin)
              const LoggedWidget()
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
      if (isLoggedIn) {
        _initUserState();
      }
    });
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
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 70.w,
                ),
                SizedBox(width: 16.w),
                Text(
                  name,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
      },
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

    if (googleUser != null) {
      userInfo = await login(googleUser.email);
      await secureStorage.saveData('userID', googleUser.email);
      if (userInfo['exceptionCode'] != null) {
        context.push('/signup');
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () async {
            context.push('/bookreport_viewing', extra: book['id']);
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
                      '${book['startDate']} ~ ${book['endDate']}',
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
                      book['type'],
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
  final VoidCallback onLibraryUpdated; // Add this line

  const MyLibraryWidget({
    super.key,
    required this.libraries,
    required this.onLibraryUpdated, // Add this line
  });

  @override
  _MyLibraryWidgetState createState() => _MyLibraryWidgetState();
}

class _MyLibraryWidgetState extends State<MyLibraryWidget> {
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
