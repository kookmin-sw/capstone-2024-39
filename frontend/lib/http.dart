import 'package:http/http.dart' as http;
import 'dart:convert';


String token = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjNmMDZhZjYzLWE5M2MtMTFlNC05Nzk3LTAwNTA1NjkwNzczZiIsImlhdCI6MTcxMzk0MTc3MSwiZXhwIjoxNzE0MDI4MTcxfQ.GObwbwgld7cE0GC6ixYO_7rhS_u571TXuGmwT-nET-ZjADhYT2ADVuAi3KD4AXYYFqHqBuy4ymx66hl5k49zVQ";

Future<String> sendData() async {
  //http.post는 리턴값이 Future이기 떄문에 async 함수 내에서 await로 호출할 수 있다.
var test = Uri.parse('http://ec2-15-165-85-185.ap-northeast-2.compute.amazonaws.com:8080/comment/1');
  http.Response res = await http.get(
    test,
    headers: {"Content-Type":"application/json",
      'Authorization': 'Bearer $token'
    },
    // body: json.encode({
    //   "email" : "example1@gmail.com",
    //   "token" : "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjNmMDZhZjYzLWE5M2MtMTFlNC05Nzk3LTAwNTA1NjkwNzczZiIsImlhdCI6MTcxMzk0MTc3MSwiZXhwIjoxNzE0MDI4MTcxfQ.GObwbwgld7cE0GC6ixYO_7rhS_u571TXuGmwT-nET-ZjADhYT2ADVuAi3KD4AXYYFqHqBuy4ymx66hl5k49zVQ",
    // })
  );
  final data = json.decode(utf8.decode(res.bodyBytes));
  final comment = data['body'];
  print(comment);
  // print(res.body);
  //여기서는 응답이 객체로 변환된 res 변수를 사용할 수 있다.
  //여기서 res.body를 jsonDecode 함수로 객체로 만들어서 데이터를 처리할 수 있다.

  return res.body; //작업이 끝났기 때문에 리턴
}