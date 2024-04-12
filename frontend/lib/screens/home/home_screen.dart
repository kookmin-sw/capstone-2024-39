import 'package:flutter/material.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/mypage/mypage_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_screen.dart';
import 'package:frontend/screens/home/search/search_screen.dart';
import 'package:frontend/screens/home/shorts/shorts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController();

  // 페이지 인덱스
  int _screenIndex = 0;

  // 페이지 목록
  final List<Widget> _screens = [
    const SearchScreen(),
    const ShortsScreen(),
    const GroupScreen(),
    const BookReportScreen(),
    const MypageScreen(),
  ];

  // 화면을 이동시킬 함수
  void _onTap(int index) {
    pageController.jumpToPage(index);
  }

  // 페이지를 업데이트하는 함수
  void _onPageChanged(int index) {
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens, // 슬라이딩으로 화면넘기기 X
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 탭 고정
        onTap: _onTap,
        currentIndex: _screenIndex,
        items: const [
          BottomNavigationBarItem(
            label: '검색',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: '숏츠',
            icon: Icon(Icons.slideshow),
          ),
          BottomNavigationBarItem(
            label: '모임',
            icon: Icon(Icons.group),
          ),
          BottomNavigationBarItem(
            label: '글쓰기',
            icon: Icon(Icons.menu_book_rounded),
          ),
          BottomNavigationBarItem(
            label: '마이페이지',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
