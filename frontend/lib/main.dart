import 'package:flutter/material.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/book/book_content_screen.dart';
import 'package:frontend/screens/book/book_info_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_template_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_viewing_screen.dart';
import 'package:frontend/screens/home/bookreport/bookreport_writing_screen.dart';
import 'package:frontend/screens/home/group/group_screen.dart';
import 'package:frontend/screens/home/group/in_group/group_info_screen.dart';
import 'package:frontend/screens/home/group/in_group/groupbook_select_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/homework_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/homework_memberlist_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/make_post/homework_make_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/make_post/post_make_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/notice_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/post_list_screen.dart';
import 'package:frontend/screens/home/group/in_group/post/post_screen.dart';
import 'package:frontend/screens/home/group/in_group/voicecall/voice_class.dart';
import 'package:frontend/screens/home/group/make_group/group_make_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/home/mypage/makelibrary_screen.dart';
import 'package:frontend/screens/home/mypage/mypage_screen.dart';
import 'package:frontend/screens/home/mypage/signup_screen.dart';
import 'package:frontend/screens/home/search/search_screen.dart';
import 'package:frontend/screens/home/shorts/shorts_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
        Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
        int index = extraData['index'] as int;
        dynamic clubId = extraData['clubId'] as dynamic;
        dynamic asId = extraData['asId'] as dynamic;
        dynamic isbn = extraData['isbn'] as dynamic;
        dynamic dateInfo = extraData['dateInfo'] as dynamic;
        return BookReportWritingScreen(
          index: index,
          clubId: clubId,
          asId: asId,
          isbn: isbn,
          dateInfo: dateInfo,
        );
      },
    ),
    GoRoute(
      name: 'bookreport_viewing',
      path: '/bookreport_viewing',
      builder: (context, state) {
        dynamic contentData = state.extra as dynamic;
        return BookReportViewingScreen(contentData: contentData);
      },
    ),
    GoRoute(
      name: 'mypage',
      path: '/mypage',
      builder: (context, state) => const MypageScreen(),
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
      builder: (context, state) {
        Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
        int clubId = extraData['clubId'] as int;
        String managerId = extraData['managerId'] as String;
        dynamic bookInfo = extraData['bookInfo'] as dynamic;
        return HomeworkListScreen(
          clubId: clubId,
          managerId: managerId,
          bookInfo: bookInfo,
        );
      },
    ),
    GoRoute(
        name: 'notice_list',
        path: '/notice_list',
        builder: (context, state) {
          Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
          int clubId = extraData['clubId'] as int;
          String managerId = extraData['managerId'] as String;
          return NoticeListScreen(
            clubId: clubId,
            managerId: managerId,
          );
        }),
    GoRoute(
        name: 'post_list',
        path: '/post_list',
        builder: (context, state) {
          Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
          int clubId = extraData['clubId'] as int;
          String managerId = extraData['managerId'] as String;
          return PostListScreen(
            clubId: clubId,
            managerId: managerId,
          );
        }),
    GoRoute(
      name: 'post',
      path: '/post',
      builder: (context, state) {
        final Map<String, dynamic> extradata =
            state.extra as Map<String, dynamic>;
        final int postId = extradata['postId'] as int;
        final int clubId = extradata['clubId'] as int;
        return PostScreen(
          postId: postId,
          clubId: clubId,
        );
      },
    ),
    GoRoute(
      name: 'post_make',
      path: '/post_make',
      builder: (context, state) {
        final Map<String, dynamic> extradata =
            state.extra as Map<String, dynamic>;
        int clubId = extradata['clubId'] as int;
        String managerId = extradata['managerId'] as String;
        return PostMakeScreen(
          clubId: clubId,
          managerId: managerId,
        );
      },
    ),
    GoRoute(
      name: 'homework_make',
      path: '/homework_make',
      builder: (context, state) {
        int clubId = state.extra as int;
        return HomeworkMakeScreen(
          clubId: clubId,
        );
      },
    ),
    GoRoute(
      name: 'homeworkmember_make',
      path: '/homeworkmember_make',
      builder: (context, state) {
        final Map<String, dynamic> extradata =
            state.extra as Map<String, dynamic>;
        int clubId = extradata['clubId'] as int;
        Map<String, dynamic> post = extradata['post'] as Map<String, dynamic>;
        return HomeworkMemberlistScreen(
          clubId: clubId,
          post: post,
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
    GoRoute(
        name: 'book_content',
        path: '/book_content',
        builder: (context, state) {
          Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
          dynamic posts = extraData['posts'] as dynamic;
          String type = extraData['type'] as String;
          String isbn = extraData['isbn'] as String;
          return BookContentScreen(
            posts: posts,
            type: type,
            isbn: isbn,
          );
        }),
    GoRoute(
      name: 'voicecall',
      path: '/voicecall',
      builder: (context, state) => const VoiceCallScreen(),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SecureStorageService()),
        // 다른 프로바이더도 여기에 추가
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
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
