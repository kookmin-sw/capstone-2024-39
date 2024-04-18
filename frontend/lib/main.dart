import 'package:flutter/material.dart';
import 'package:frontend/screens/home/bookreport/bookreport_writing_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/home/search/search_screen.dart';
import 'package:frontend/screens/home/shorts/shorts_screen.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_screen.dart';
import 'package:frontend/screens/home/mypage/mypage_screen.dart';
import 'package:frontend/screens/home/group/group_info_screen.dart';
import 'package:frontend/screens/home/group/group_make_screen.dart';

void main() async {
  runApp(const App());
  // provider 모델이 여러 개인 경우 List를 통해 제공
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => FilterList()),
  //       ChangeNotifierProvider(create: (context) => AnotherModel()),
  //
  //     ],
  //     child: const App(),
  //   ),
  // );
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'search',
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      name: 'shorts',
      path: '/shorts',
      builder: (context, state) => const ShortsScreen(),
    ),
    GoRoute(
      name: 'group',
      path: '/group',
      builder: (context, state) => const GroupScreen(),
    ),
    GoRoute(
      name: 'group_info',
      path: '/group_info',
      builder: (context, state){
        String groupname = state.extra.toString();
        return GroupInfoScreen(
          groupName: groupname,
        );
      } 
    ),
    GoRoute(
      name: 'bookreport_writing',
      path: '/bookreport_writing',
      builder: (context, state) {
        String title = state.extra.toString();
        return BookReportWritingScreen(title: title);
      },
    ),
    GoRoute(
      name: 'mypage',
      path: '/mypage',
      builder: (context, state) => const GroupScreen(),
    ),
    GoRoute(
      name: 'group_make',
      path: '/group_make',
      builder: (context, state) => const GroupMakeScreen(),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'pretendard',
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
          primarySwatch: Colors.green,
          accentColor: const Color(0xFF09BB10),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w200,
          ),
          titleLarge: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w700),
          titleMedium: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
