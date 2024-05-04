import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/home/search/search_screen.dart';

//검색의 리스트 아이템 템플릿

class SearchListItem extends StatefulWidget {
  final Map<String, dynamic> data;

  const SearchListItem({
    super.key,
    required this.data,
  });

  @override
  State<SearchListItem> createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          width: ScreenUtil().setWidth(370),
          height: ScreenUtil().setHeight(105),
          child: InkWell(
            onTap: () {
              context.push(
                '/book_info',
                extra: widget.data,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setHeight(105),
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
                  width: ScreenUtil().setWidth(5),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(280),
                      child: Text(
                        widget.data['title'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: (widget.data['title'].length < 50)? 20:13,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(280),
                      child: Text(
                        "${(widget.data['author'] == '')?'저자 미상':widget.data['author']} | ${widget.data['publisher']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        )
      ],
    );
  }
}
