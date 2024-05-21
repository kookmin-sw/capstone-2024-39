import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/home/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/http.dart';
import 'package:frontend/env.dart';

//검색의 리스트 아이템 템플릿

class SearchListItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  final int clubId;

  const SearchListItem({
    super.key,
    required this.data,
    required this.type,
    required this.clubId
  });

  @override
  State<SearchListItem> createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    return Column(
      children: [
        Ink(
          width: 370.w,
          height: 105.h,
          child: InkWell(
            onTap: () async{
              switch (widget.type) {
                case "search":
                  await bookAdd(widget.data);
                  // print(result);
                  // if(result == "도서 추가 완료"){ // 새로운 책
                    
                  // }
                  // else{ //이미 있는 책
                  //   await getBookInfo(widget.data['isbn']);
                  // }
                  context.push(
                    '/book_info',
                    extra: widget.data,
                  );
                  break;
                case "select":
                  var token = await secureStorage.readData("token");
                  String result = await groupBookSelect(token, widget.data, widget.clubId);
                  if(result == "선정 완료"){
                    Navigator.pop(context, true);
                  }
                  break;
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 105.h,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.data['image']),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 280.w,
                      child: Text(
                        widget.data['title'],
                        style: textStyle(20, Colors.black, true),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      width: ScreenUtil().setWidth(280),
                      child: Text(
                        "${(widget.data['author'] == '') ? '저자 미상' : widget.data['author']} | ${widget.data['publisher']}",
                        style: textStyle(11, Colors.black, false),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
