import 'dart:convert';

import 'package:frontend/secret.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml2json/xml2json.dart';

const String NaverBookSearchURL =
    "https://openapi.naver.com/v1/search/book.json";
const String NaverBookISBNSearchURL =
    "https://openapi.naver.com/v1/search/book_adv.xml";

//네이버 책 검색
Future<List<dynamic>> SearchBook(String SearchString) async {
  List<dynamic> bookData = [];
  int iter = 0;
  var address =
      Uri.parse(NaverBookSearchURL + "?query=$SearchString&display=100");
  http.Response res = await http.get(address, headers: {
    "Content-Type": "application/json",
    "X-Naver-Client-Id": NaverClientID,
    "X-Naver-Client-Secret": NaverSecret,
  });
  final data = json.decode(utf8.decode(res.bodyBytes));
  while (iter != 100) {
    if (data['total'] <= iter) {
      break;
    } else if (data['items'][iter]['title'].toString().contains('시리즈')) {
    } else if (data['items'][iter]['title'].toString().contains('세트')) {
    } else {
      bookData.add(data['items'][iter]);
    }
    iter++;
  }

  return bookData;
}

//네이버 책 상세검색(ISBN 검색)
Future<dynamic> SearchISBNBook(String ISBN) async {
  var address = Uri.parse(NaverBookISBNSearchURL + "?d_isbn=$ISBN");
  http.Response res = await http.get(address, headers: {
    "X-Naver-Client-Id": NaverClientID,
    "X-Naver-Client-Secret": NaverSecret,
  });

  final responseBody = res.body;
  final xml2Json = Xml2Json();
  xml2Json.parse(responseBody);
  final data = jsonDecode(xml2Json.toParker());

  return data['rss']['channel']['item'];
}

//회원 가입
Future<dynamic> singup(
    String email, String name, int age, String gender) async {
  var address = Uri.parse(BASE_URL + "/auth/signup");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
    },
    body: json.encode({
      "email": email,
      "name": name,
      "age": age,
      "gender": gender,
    }),
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  // print(data);

  return data;
}

//로그인
Future<dynamic> login(String email) async {
  var address = Uri.parse(BASE_URL + "/auth/login");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
    },
    body: json.encode({
      "email": email,
    }),
  );
  final data = json.decode(utf8.decode(res.bodyBytes));

  return data;
}

//유저 정보 가져오기
Future<dynamic> getUserInfo(String id, String token) async {
  var address = Uri.parse("$BASE_URL/member/$id");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));

  return data;
}

//모임 목록 가져오기(주제를 기반으로)›
Future<List<List<dynamic>>> groupSerachforTopic(List<String> topic) async {
  List<List<dynamic>> groupList = [[], [], [], [], [], []];
  for (int i = 0; i < topic.length; i++) {
    String temp = topic[i];
    var address = Uri.parse(BASE_URL + "/club/search/topic?topic=$temp");
    http.Response res = await http.get(
      address,
      headers: {
        "Content-Type": "application/json",
      },
    );
    final data = json.decode(utf8.decode(res.bodyBytes));
    for (int j = 0; j < data.length; j++) {
      groupList[i].add(data[j]);
    }
  }

  return groupList;
}

//모임 정보 가져오기(id를 기반으로)
Future<dynamic> groupSerachforId(int clubId) async {
  var address = Uri.parse(BASE_URL + "/club/search/$clubId");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  // print(data);
  return data;
}

//모임 목록 가져오기(이름을 기반으로)
Future<dynamic> groupSerachforName(String name) async {
  var address = Uri.parse(BASE_URL + "/club/search/name?name=$name");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  // print(data);
  return data;
}

//모임 목록 가져오기(대표책을 기반으로)
Future<List<dynamic>> groupSerachforBook(String title) async {
  var address = Uri.parse(BASE_URL + "/club/search/book?title=$title");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  // print(data);
  return data;
}

//모임 생성하기
Future<dynamic> groupCreate(dynamic token, String name, String topic,
    int maximum, String publication, var password) async {
  var address = Uri.parse(BASE_URL + "/club/create");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode({
      "topic": topic,
      "name": name,
      "maximum": maximum,
      "publicStatus": publication,
      "password": password,
    }),
  );
  final data = res.body;

  return data;
}

//컨텐츠 생성하기
Future<dynamic> contentCreate(
    dynamic token,
    dynamic clubId,
    dynamic asId,
    String isbn,
    String booktitle,
    String description,
    String author,
    String publisher,
    String publishDate,
    String imageUrl,
    String contentType,
    String title,
    String body,
    String startDate,
    String endDate) async {
  var address;
  // print(clubId);
  if (clubId == null) {
    address = Uri.parse("$BASE_URL/content/create?");
  } else {
    address = Uri.parse("$BASE_URL/content/create?clubId=$clubId&asId=$asId");
  }
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode({
      "addBookRequest": {
        "isbn": isbn,
        "title": booktitle,
        "description": description,
        "author": author,
        "publisher": publisher,
        "publishDate": publishDate,
        "imageUrl": imageUrl,
      },
      "contentType": contentType,
      "title": title,
      "body": body,
      "startDate": startDate,
      "endDate": endDate,
    }),
  );
  final data = res.body;
  //final data = json.decode(utf8.decode(res.bodyBytes));
  print(data);
  return data;
}

//퀴즈 생성하기
Future<dynamic> quizCreate(
    dynamic token,
    dynamic clubId,
    dynamic asId,
    String isbn,
    String booktitle,
    String author,
    String publisher,
    String publishDate,
    String imageUrl,
    String type,
    String description,
    var answer,
    var example1,
    var example2,
    var example3,
    var example4,
    String startDate,
    String endDate) async {
  var address;
  if (clubId == null) {
    print(clubId);
    address = Uri.parse("$BASE_URL/quiz/create?");
  } else {
    address = Uri.parse("$BASE_URL/quiz/create?clubId=$clubId&asId=$asId");
  }
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode({
      "addBookRequest": {
        "isbn": isbn,
        "title": booktitle,
        "author": author,
        "publisher": publisher,
        "publishDate": publishDate,
        "imageUrl": imageUrl,
      },
      "type": type,
      "description": description,
      "answer": answer,
      "example1": example1,
      "example2": example2,
      "example3": example3,
      "example4": example4,
      "startDate": startDate,
      "endDate": endDate,
    }),
  );
  final data = res.body;
  print(data);
  return data;
}

//컨텐츠 불러오기
Future<List<dynamic>> contentLoad(int id) async {
  List<dynamic> contentList = [];
  var address = Uri.parse("$BASE_URL/content/search/$id");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  for (int i = 0; i < data.length; i++) {
    contentList.add(data[i]);
  }
  return contentList;
}

//해당 책의 컨텐츠 불러오기
Future<List<dynamic>> bookcontentLoad(String ISBN, String content) async {
  List<dynamic> contentList = [];
  var address = Uri.parse("$BASE_URL/book/$ISBN/content?type=$content");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  for (int i = 0; i < data.length; i++) {
    contentList.add(data[i]);
  }
  return contentList;
}

//해당 책의 퀴즈 불러오기
Future<List<dynamic>> bookQuizLoad(String ISBN) async {
  List<dynamic> contentList = [];
  var address = Uri.parse("$BASE_URL/book/$ISBN/quiz");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  for (int i = 0; i < data.length; i++) {
    contentList.add(data[i]);
  }
  return contentList;
}

// 모임 가입하기
Future<String> groupJoin(String token, int clubId) async {
  var address = Uri.parse(BASE_URL + "/club/join?clubId=$clubId");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
  final data = res.body;

  return data;
}

//모임 나가기
Future<String> groupOut(String token, int clubId) async {
  var address = Uri.parse(BASE_URL + "/club/out?clubId=$clubId");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
  final data = res.body;

  return data;
}

//모임 추방하기
Future<String> groupExpel(String token, String memberId, int clubId) async {
  var address =
      Uri.parse(BASE_URL + "/club/expel?memberId=$memberId&clubId=$clubId");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
  final data = res.body;
  return data;
}

//모임장 임명하기
Future<String> groupDelegate(String token, String memberId, int clubId) async {
  var address =
      Uri.parse(BASE_URL + "/club/delegate?memberId=$memberId&clubId=$clubId");
  http.Response res = await http.put(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
  final data = res.body;
  return data;
}

//대표 책 선정
Future<String> groupBookSelect(
    dynamic token, Map<String, dynamic> bookdata, int clubId) async {
  String originalDate = bookdata['pubdate'];
  DateTime parsedDate = DateTime.parse(originalDate.replaceAllMapped(
      RegExp(r'(\d{4})(\d{2})(\d{2})'),
      (Match m) => '${m[1]}-${m[2]}-${m[3]}'));
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
  var address = Uri.parse(BASE_URL + "/club/book?clubId=$clubId");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode({
      "isbn": bookdata['isbn'],
      "title": bookdata['title'],
      "author": bookdata['author'],
      "publisher": bookdata['publisher'],
      "publishDate": formattedDate,
      "imageUrl": bookdata['image'],
    }),
  );
  final data = res.body;

  return data;
}

//책 추가하기
Future<String> bookAdd(Map<String, dynamic> bookdata) async {
  String originalDate = bookdata['pubdate'];
  DateTime parsedDate = DateTime.parse(originalDate.replaceAllMapped(
      RegExp(r'(\d{4})(\d{2})(\d{2})'),
      (Match m) => '${m[1]}-${m[2]}-${m[3]}'));
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
  var address = Uri.parse(BASE_URL + "/book/add");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
    },
    body: json.encode({
      "isbn": bookdata['isbn'],
      "title": bookdata['title'],
      "author": bookdata['author'],
      "publisher": bookdata['publisher'],
      "publishDate": formattedDate,
      "imageUrl": bookdata['image'],
    }),
  );

  if (res.contentLength == 20) {
    final data = res.body;
    return data;
  } else {
    final data = json.decode(utf8.decode(res.bodyBytes));
    return data['message'];
  }
}

//책 기본 정보 불러오기
Future<dynamic> getBookInfo(String isbn) async {
  var address = Uri.parse(BASE_URL + "/book/search/$isbn");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));

  // print(data);
  return data;
}

//과제 불러오기
Future<dynamic> getAssign(int clubId) async {
  var address = Uri.parse(BASE_URL + "/assign/search/get?clubId=$clubId");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  var data = json.decode(utf8.decode(res.bodyBytes));
  // print(data);
  return data;
}

//과제 생성하기
Future<String> assignCreate(String token, int clubId, String name, String type,
    String startDate, String endDate) async {
  var address = Uri.parse(BASE_URL + "/assign/create?clubId=$clubId");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: json.encode({
      "name": name,
      "type": type,
      "startDate": startDate,
      "endDate": endDate,
    }),
  );
  final data = res.body;

  // print(data);
  return data;
}

//게시글 불러오기
Future<dynamic> getPost(String token, int postId, int clubId) async {
  var address = Uri.parse(BASE_URL + "/post/$postId?clubId=$clubId");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));

  return data;
}

//게시글 만들기
Future<String> postCreate(
    String token, int clubId, String title, String body, bool isSticky) async {
  var address = Uri.parse(BASE_URL + "/post/create?clubId=$clubId");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: json.encode({
      "title": title,
      "body": body,
      "isSticky": isSticky,
    }),
  );
  final data = res.body;

  return data;
}

//댓글 작성
Future<String> commentCreate(dynamic token, int postId, String body) async {
  var address = Uri.parse(BASE_URL + "/comment/create?postId=$postId");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode({
      "body": body,
    }),
  );
  final data = res.body;

  return data;
}

//서재 불러오기
Future<List<dynamic>> getLibrary(String token) async {
  List<dynamic> libraryList = [];
  var address = Uri.parse("$BASE_URL/member/my-book");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  for (int i = 0; i < data.length; i++) {
    libraryList.add(data[i]);
  }
  return libraryList;
}

//서재에 책 추가하기
Future<String> addBookToLibrary(
    String token,
    String isbn,
    String title,
    String description,
    String author,
    String publisher,
    String publishDate,
    String imageUrl) async {
  var address = Uri.parse("$BASE_URL/member/my-book/add");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode({
      "isbn": isbn,
      "title": title,
      "description": description,
      "author": author,
      "publisher": publisher,
      "publishDate": publishDate,
      "imageUrl": imageUrl,
    }),
  );
  final data = res.body;
  return data;
}

//서재에 책 여러권 추가하기
Future<String> addBooksToLibrary(
    String token, String groupName, List<dynamic> books) async {
  var address = Uri.parse("$BASE_URL/member/my-book/adds?groupName=$groupName");
  http.Response res = await http.post(
    address,
    headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    },
    body: json.encode(books),
  );
  final data = res.body;
  print(data);
  return data;
}
