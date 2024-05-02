import 'package:flutter/material.dart';
import 'package:frontend/provider/bookinfo_provider.dart';
import 'package:frontend/screens/home/bookreport/bookreport_template_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_writing_screen.dart';
import 'package:frontend/screens/home/mypage/login_screen.dart';
import 'package:frontend/screens/home/mypage/mypage_screen.dart';
import 'package:frontend/screens/home/mypage/signup_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/home/search/search_screen.dart';
import 'package:frontend/screens/home/shorts/shorts_screen.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/home/group/in_group/group_info_screen.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/homework_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/notice_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/post_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/post_screen.dart';

void main() async {
  runApp(const App());
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
        builder: (context, state) {
          String groupname = state.extra.toString();
          return GroupInfoScreen(
            groupName: groupname,
          );
        }),
    GoRoute(
      name: 'bookreport_template',
      path: '/bookreport_template',
      builder: (context, state) {
        String title = state.extra.toString();
        return BookReportTemplateScreen(title: title);
      },
    ),
    GoRoute(
      name: 'bookreport_writing',
      path: '/bookreport_writing',
      builder: (context, state) {
        int index = state.extra as int;
        return BookReportWritingScreen(index: index);
      },
    ),
    GoRoute(
      name: 'mypage',
      path: '/mypage',
      builder: (context, state) => const MypageScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      name: 'group_make',
      path: '/group_make',
      builder: (context, state) => const GroupMakeScreen(),
    ),
    GoRoute(
      name: 'homework_list',
      path: '/homework_list',
      builder: (context, state) => const HomeworkListScreen(),
    ),
    GoRoute(
      name: 'notice_list',
      path: '/notice_list',
      builder: (context, state) => const NoticeListScreen(),
    ),
    GoRoute(
      name: 'post_list',
      path: '/post_list',
      builder: (context, state) => const PostListScreen(),
    ),
    GoRoute(
      name: 'post',
      path: '/post',
      builder: (context, state) {
        final Map<String, dynamic> extraData =
            state.extra as Map<String, dynamic>;
        final String postTitle = extraData['title'] as String;
        final String postBody = extraData['body'] as String;

        return PostScreen(title: postTitle, body: postBody);
      },
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookInfoProvider()),
        // 다른 프로바이더도 여기에 추가
      ],
      child: MaterialApp.router(
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
      ),
    );
  }
}
