import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/screens/home/bookreport/bookreport_viewing_screen.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsState();
}

class _ShortsState extends State<ShortsScreen> {
  List<dynamic> review = [];
  List<dynamic> quotation = [];
  List<dynamic> shortreview = [];
  List<dynamic> quiz = [];
  var userInfo;
  var secureStorage;
  bool _isLoading = true;
  late PageController _pageController;
  Timer? _pageTimer;
  // int _currentPage = 0;
  int sumPages = 0;
  // List<dynamic> allShorts = [];

  Future<void> shortsList() async {
    List<dynamic> _review = [];
    List<dynamic> _quotation = [];
    List<dynamic> _shortreview = [];
    List<dynamic> _quiz = [];
    var isbnList;

    try {
      // var id = await secureStorage.readData('id');
      var token = await secureStorage.readData('token');
      isbnList = await getRecommend(token);
    } catch (e) {
      isbnList = await getRecommendAnony();
    }

    for (String isbn in isbnList['isbnList']) {
      _review.add(await bookcontentLoad(isbn, 'Review'));
      _quotation.add(await bookcontentLoad(isbn, 'Quotation'));
      _shortreview.add(await bookcontentLoad(isbn, 'ShortReview'));
      _quiz.add(await bookQuizLoad(isbn));
    }

    setState(() {
      print(isbnList);
      review = _review; //각각 10개의 리스트들이 존재
      quotation = _quotation;
      shortreview = _shortreview;
      quiz = _quiz;
      // allShorts = [quiz, quotation, shortreview, review];
      // print(review[0].isEmpty);
      // print(quotation);
      // print(shortreview);
      // print(quiz);
      // print(allShorts.isEmpty);
    });
  }

  List<Widget> shortsPage(List<dynamic> posts) {
    List<Widget> temp = [];
    int chekpoint = 0;
    for (int i = 0; i < posts.length; i++) {
      if (posts[i].isNotEmpty) {
        for (var post in posts[i]) {
          temp.add(BookReportViewingScreen(contentData: post));
          chekpoint++;
        }
      } else {
        temp.add(Center(child: SizedBox(child: Text('컨텐츠가 존재하지 않습니다.'))));
        chekpoint++;
      }
    }
    sumPages += chekpoint;
    return temp;
  }

  Future<void> _loadData() async {
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
        _startPageTimer();
      });
    });
  }

  void _startPageTimer() {
    _pageTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        int currentPage = _pageController.page!.toInt();
        int nextPage = currentPage + 1;
        // _currentPage++;
        // print(_currentPage);
        if (nextPage >= sumPages) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      
    });
  }

  void _resetPageTimer() {
    _pageTimer?.cancel();
    _startPageTimer();
  }

  @override
  void initState() {
    super.initState();
    secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    _pageController = PageController(initialPage: 0);
    shortsList();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => _isLoading
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100.h),
                child: const CircularProgressIndicator(),
              ),
            )
          : GestureDetector(
              // onPanDown: (details) {
              //   setState(() {
              //     _pageTimer?.cancel();
              //   });
              // },
              

              onPanEnd: (details) {
                setState(() {
                  _resetPageTimer();
                });
              },
              onTapDown: (details) {
                setState(() {
                  _pageTimer?.cancel();
                  print('here');
                });
              },
              onTapUp: (details) {
                setState(() {
                  _resetPageTimer();
                  print('reset'); 
                });
              },
              child: Center(
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  children: [
                    ...shortsPage(review),
                    ...shortsPage(quotation),
                    ...shortsPage(quiz),
                    ...shortsPage(shortreview),
                  ],
                ),
              ),
            ),
    );
  }
}
