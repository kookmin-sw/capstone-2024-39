import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';
import 'package:frontend/secret.dart';
import 'dart:convert';

const String NaverBookSearchURL =
    "https://openapi.naver.com/v1/search/book.json";
const String NaverBookISBNSearchURL =
    "https://openapi.naver.com/v1/search/book_adv.xml";

//네이버 책 검색
Future<List<dynamic>> SearchBook(String SearchString) async {
  List<dynamic> bookData = [];
  int cnt = 0, iter = 0;
  var address =
      Uri.parse(NaverBookSearchURL + "?query=$SearchString&display=100");
  http.Response res = await http.get(address, headers: {
    "Content-Type": "application/json",
    "X-Naver-Client-Id": NaverClientID,
    "X-Naver-Client-Secret": NaverSecret,
  });
  final data = json.decode(utf8.decode(res.bodyBytes));
  while (cnt != 10) {
    if (data['items'][iter]['title'].toString().contains('시리즈')) {
      iter++;
      continue;
    } else {
      bookData.add(data['items'][iter]);
      iter++;
      cnt++;
    }
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
  // print(data);

  return data;
}

//유저 정보 가져오기
Future<dynamic> getUserInfo(String id, String token) async {
  var address = Uri.parse(BASE_URL + "/member/$id");
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
  List<List<dynamic>> groupList = [[], [], [], [], []];
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

//모임 목록 가져오기(id를 기반으로)
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
  // print(res.body);

  return data;
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
