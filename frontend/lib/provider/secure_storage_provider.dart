import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SecureStorageService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const _storage = FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    notifyListeners();
  }

  Future<String?> readData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
    notifyListeners();
  }

  Future<void> deleteAllData() async {
    await _secureStorage.deleteAll();
    notifyListeners();
  }
}

class SecureStorageProvider extends StatelessWidget {
  final Widget child;

  const SecureStorageProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SecureStorageService>(
      create: (_) => SecureStorageService(),
      child: child,
    );
  }

  static SecureStorageService of(BuildContext context) {
    return context.read<SecureStorageService>();
  }
}

class SecureStorageUtil {
  static const _storage = FlutterSecureStorage();

  static Future<void> addBook(TmpBook newBook) async {
    List<TmpBook> currentBooks = await loadBooks();
    currentBooks.add(newBook);
    await saveBooks(currentBooks);
  }

  static Future<void> saveBooks(List<TmpBook> books) async {
    String jsonString = jsonEncode(books.map((book) => book.toJson()).toList());
    await _storage.write(key: 'books', value: jsonString);
  }

  static Future<List<TmpBook>> loadBooks() async {
    String? jsonString = await _storage.read(key: 'books');
    if (jsonString == null) {
      return [];
    }
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => TmpBook.fromJson(json)).toList();
  }

  static Future<void> deleteBook(int index) async {
    List<TmpBook> currentBooks = await loadBooks();
    currentBooks.removeAt(index);
    await saveBooks(currentBooks);
  }

  static Future<void> deleteAllBooks() async {
    await _storage.delete(key: 'books');
  }
}

class TmpBook {
  String title;
  String imageUrl;
  DateTime startDate;
  DateTime endDate;
  String template;
  String booktitle;
  String author;
  String publisher;
  String writing;
  String isbn;
  String description;
  String publisherDate;

  TmpBook({
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.template,
    required this.booktitle,
    required this.author,
    required this.publisher,
    required this.writing,
    required this.isbn,
    required this.description,
    required this.publisherDate,
  });

  factory TmpBook.fromJson(Map<String, dynamic> json) {
    return TmpBook(
      title: json['title'],
      imageUrl: json['imageUrl'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      template: json['template'],
      booktitle: json['booktitle'],
      author: json['author'],
      publisher: json['publisher'],
      writing: json['writing'],
      isbn: json['isbn'],
      description: json['description'],
      publisherDate: json['publisherDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'template': template,
      'booktitle': booktitle,
      'author': author,
      'publisher': publisher,
      'writing': writing,
      'isbn': isbn,
      'description': description,
      'publisherDate': publisherDate,
    };
  }
}
