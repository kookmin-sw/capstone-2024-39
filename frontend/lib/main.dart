import 'package:flutter/material.dart';
import 'package:frontend/provider/bookinfo_provider.dart';
import 'package:frontend/provider/grouplist_provider.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/bookreport/bookreport_template_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_viewing_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_writing_screen.dart';
import 'package:frontend/screens/home/mypage/login_screen.dart';
import 'package:frontend/screens/home/mypage/makelibrary_screen.dart';
import 'package:frontend/screens/home/mypage/mypage_screen.dart';
import 'package:frontend/screens/home/mypage/signup_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/home/search/search_screen.dart';
import 'package:frontend/screens/home/shorts/shorts_screen.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/group/in_group/group_info_screen.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/homework_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/notice_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/post_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/post_screen.dart';
import 'package:frontend/screens/book/book_info_screen.dart';
import 'package:frontend/screens/home/group/in_group/groupbook_select_screen.dart';

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
          final Map<String, dynamic> groupData =
              state.extra as Map<String, dynamic>;
          final int id = groupData['id'] as int;
          final String groupName = groupData['groupName'] as String;
          return GroupInfoScreen(
            clubId: id,
            groupName: groupName,
          );
        }),
    GoRoute(
      name: 'groupbook_select',
      path: '/groupbook_select',
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        String title = data['title'] as String;
        int clubId = data['clubId'] as int;
        return GroupBookSelectScreen(
          title: title,
          clubId: clubId,
        );
      },
    ),
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
      name: 'bookreport_viewing',
      path: '/bookreport_viewing',
      builder: (context, state) => const BookReportViewingScreen(),
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
      name: 'make_library',
      path: '/make_library',
      builder: (context, state) => const MakeLibraryScreen(),
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
        builder: (context, state) {
          List<dynamic> posts = state.extra as List<dynamic>;
          return NoticeListScreen(
            posts: posts,
          );
        }),
    GoRoute(
        name: 'post_list',
        path: '/post_list',
        builder: (context, state) {
          List<dynamic> posts = state.extra as List<dynamic>;
          return PostListScreen(
            posts: posts,
          );
        }),
    GoRoute(
      name: 'post',
      path: '/post',
      builder: (context, state) {
        final Map<String, dynamic> extradata =
            state.extra as Map<String, dynamic>;
        // final String postTitle = extraData['title'] as String;
        // final bool kindOf = extraData['kindOf'] as bool;
        // final String postBody = extraData['body'] as String;
        // final List<dynamic> comments = extraData["commentResponseList"] as List<dynamic>;
        // Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        final int postId = extradata['postId'] as int;
        final int clubId = extradata['clubId'] as int;

        return PostScreen(
          // title: postTitle,
          // body: postBody,
          // kindOf: kindOf,
          // comments: comments,
          postId: postId,
          clubId: clubId,
          // data: data,
        );
      },
    ),
    GoRoute(
        name: 'book_info',
        path: '/book_info',
        builder: (context, state) {
          Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return BookInfoScreen(
            data: data,
          );
        }),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookInfoProvider()),
        ChangeNotifierProvider(create: (_) => SecureStorageService()),
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
