import 'package:flutter/material.dart';

class BookInfoProvider with ChangeNotifier {
  List<Book> books = [
    Book(
      title: '독후감',
      imageUrl: 'https://via.placeholder.com/60x86',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().subtract(const Duration(days: 6)),
      isPublic: true,
      template: '독후감',
    ),
    Book(
      title: '한줄평',
      imageUrl: 'https://via.placeholder.com/60x86',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().subtract(const Duration(days: 4)),
      isPublic: true,
      template: '한줄평',
    ),
    Book(
      title: '인용구',
      imageUrl: 'https://via.placeholder.com/60x86',
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      endDate: DateTime.now().subtract(const Duration(days: 2)),
      isPublic: true,
      template: '인용구',
    ),
    Book(
      title: '퀴즈',
      imageUrl: 'https://via.placeholder.com/60x86',
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now(),
      isPublic: true,
      template: '퀴즈',
    ),
  ];

  void addBook(Book book) {
    books.add(book);
    notifyListeners();
  }

  void removeBook(Book book) {
    books.remove(book);
    notifyListeners();
  }

  void updateBook(Book book) {
    final index = books.indexWhere((element) => element.title == book.title);
    if (index >= 0) {
      books[index] = book;
      notifyListeners();
    }
  }

  Book getBook(String title) {
    return books.firstWhere((element) => element.title == title);
  }
}

class Book {
  final String title;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isPublic;
  final String template;

  Book({
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.isPublic,
    required this.template,
  });
}
