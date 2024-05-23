import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookSearchListItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  final int clubId;
  final Function(Map<String, dynamic>) onSelected;

  const BookSearchListItem({
    super.key,
    required this.data,
    required this.type,
    required this.clubId,
    required this.onSelected,
  });

  @override
  State<BookSearchListItem> createState() => _BookSearchListItemState();
}

class _BookSearchListItemState extends State<BookSearchListItem> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Column(
        children: [
          GestureDetector(
            onTap: () {
              widget.onSelected(widget.data);
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
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 177.w,
                      child: Text(
                        widget.data['title'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 177.w,
                      child: Text(
                        "${(widget.data['author'] == '') ? '저자 미상' : widget.data['author']} | ${widget.data['publisher']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
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
        ],
      ),
    );
  }
}
