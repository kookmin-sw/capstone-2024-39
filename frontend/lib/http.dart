import 'package:http/http.dart' as http;
import 'package:frontend/secret.dart';
import 'dart:convert';

//회원 가입
Future<String> singup(String email, String name, int age, String gender) async {
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
  print(data);

  return data['token'];
}

//로그인
Future<String> login(String email) async {
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
  print(data);

  return data['token'];
}

//모임 목록 가져오기(주제를 기반으로)›
Future<List<dynamic>> groupSerachforTopic(String topic) async {
  List<dynamic> groupList = [];
  var address = Uri.parse(BASE_URL + "/club/search/topic?topic=$topic");
  http.Response res = await http.get(
    address,
    headers: {
      "Content-Type": "application/json",
    },
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  for (int i = 0; i < data.length; i++) {
    groupList.add(data[i]);
    // print(data[i]);
  }

  return groupList;
}

//모임 생성하기
Future<dynamic> groupCreate(dynamic token,  String name, String topic, int maximum, String publication, var password) async {
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
