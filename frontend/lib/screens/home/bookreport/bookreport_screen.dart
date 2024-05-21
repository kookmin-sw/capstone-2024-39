import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:go_router/go_router.dart';

class BookReportScreen extends StatefulWidget {
  const BookReportScreen({super.key});

  @override
  State<BookReportScreen> createState() => _BookReportState();
}

class _BookReportState extends State<BookReportScreen> {
  List<TmpBook> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    List<TmpBook> books = await SecureStorageUtil.loadBooks();
    setState(() {
      _books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('글쓰기'),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
          backgroundColor: const Color(0xFF0E9913),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: _books.length + 1,
          itemBuilder: (context, index) {
            if (index < _books.length) {
              return _buildBookReportEntry(context, _books[index], index);
            } else {
              return _buildNewWritingEntry(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBookReportEntry(BuildContext context, TmpBook book, int index) {
    return InkWell(
      onTap: () {
        context.push('/bookreport_writing', extra: {'index': index}).then((_) {
          _loadBooks();
        });
      },
      child: Container(
        height: 105.68.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x3F000000),
              blurRadius: 6.r,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 85.68.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(book.imageUrl),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.sp,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    book.template,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.sp,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              '이어쓰기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewWritingEntry(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/bookreport_template').then((_) {
          _loadBooks();
        });
      },
      child: Container(
        height: 105.68.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x3F000000),
              blurRadius: 6.r,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 24.sp, color: Colors.black),
              Text(
                '새로쓰기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
