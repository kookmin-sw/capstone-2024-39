import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookReportScreen extends StatefulWidget {
  const BookReportScreen({super.key});

  @override
  State<BookReportScreen> createState() => _BookReportState();
}

class _BookReportState extends State<BookReportScreen> {
  // Updated dummy data for the list of books with more entries
  final List<Map<String, String>> books = [
    {"title": "첫 번째 책", "imageUrl": "https://via.placeholder.com/60x86"},
    {"title": "두 번째 책", "imageUrl": "https://via.placeholder.com/60x86"},
    {"title": "세 번째 책", "imageUrl": "https://via.placeholder.com/60x86"},
    // Add more book entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length + 1, // +1 for the '새로쓰기' entry
      itemBuilder: (context, index) {
        if (index < books.length) {
          // Build '이어쓰기' book entry
          return _buildBookReportEntry(
            context,
            books[index]['title']!,
            books[index]['imageUrl']!,
            '이어쓰기',
          );
        } else {
          // Build '새로쓰기' entry for the last item
          return _buildNewWritingEntry(context);
        }
      },
    );
  }

  Widget _buildBookReportEntry(
      BuildContext context, String title, String imageUrl, String buttonText) {
    return InkWell(
      onTap: () {
        // Implement onTap functionality for '이어쓰기'
        context.push('/bookreport_writing', extra: title);
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
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              buttonText,
              style: const TextStyle(
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
        // Implement onTap functionality for '새로쓰기'
        context.push('/bookreport_writing');
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
