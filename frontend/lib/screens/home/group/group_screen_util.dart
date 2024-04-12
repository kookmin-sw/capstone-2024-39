import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

//그룹 탭의 리스트 아이템 템플릿

class GroupListItem extends StatefulWidget {
  final String groupName;

  const GroupListItem({
    super.key,
    required this.groupName,
  });

  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ink(
          width: 180.w,
          height: 90.h,
          child: InkWell(
            child: Row(
              children: [
                SizedBox(
                  // 책사진 넣는 곳
                  width: 60.w,
                  height: 60.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '주제:${widget.groupName}', 
                        style: TextStyle(
                          fontSize: 14.sp
                        )
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.groupName, 
                        style: TextStyle(
                          fontSize: 16.sp, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(
                        height: 4.h
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.people, 
                            size: 14.w
                          ), // 인원수 아이콘
                          SizedBox(
                            width: 4.w
                          ),
                          Text(
                            '현재 인원수', 
                            style: TextStyle(
                              fontSize: 14.sp
                            )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.h
                      ),
                      Text(
                        '공개/비공개', 
                        style: TextStyle(
                          fontSize: 14.sp
                        )
                      ),
                    ],
                   ),
                  ),
                ),
              ],
            ),
            onTap: () {
              // 나중엔 눌렀을 각 정보를 불러와서 그걸 푸쉬하는 방식으로
              context.push(
                '/group_info',
                extra: widget.groupName,
              );
            },
            borderRadius: BorderRadius.circular(15),
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Color(0xFFEEF1F4),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
      ],
    );
  }
}