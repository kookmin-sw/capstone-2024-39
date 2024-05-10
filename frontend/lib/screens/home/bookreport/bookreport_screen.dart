import 'package:flutter/material.dart';
import 'package:frontend/provider/bookinfo_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BookReportScreen extends StatefulWidget {
  const BookReportScreen({super.key});

  @override
  State<BookReportScreen> createState() => _BookReportState();
}

class _BookReportState extends State<BookReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookInfoProvider>(
      builder: (context, bookInfoProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('글쓰기'),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            backgroundColor: const Color(0xFF0E9913),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: bookInfoProvider.books.length + 1,
            itemBuilder: (context, index) {
              if (index < bookInfoProvider.books.length) {
                return _buildBookReportEntry(
                    context, bookInfoProvider.books[index], index);
              } else {
                return _buildNewWritingEntry(context);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBookReportEntry(BuildContext context, Book book, int index) {
    return InkWell(
      onTap: () {
        context.push('/bookreport_writing', extra: index);
      },
      child: Container(
        height: 105.68,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 85.68,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(book.imageUrl),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                book.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Text(
              '이어쓰기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
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
        context.push('/bookreport_template');
      },
      child: Container(
        height: 105.68,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 24, color: Colors.black),
              Text(
                '새로쓰기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
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
