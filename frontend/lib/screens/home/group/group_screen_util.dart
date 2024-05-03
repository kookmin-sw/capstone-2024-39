import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

//그룹 탭의 리스트 아이템 템플릿

class GroupListItem extends StatefulWidget {
  final String groupName;
  final int groupCnt;
  final String publicState;
  final String topic;

  const GroupListItem({
    super.key,
    required this.groupName,
    required this.groupCnt,
    required this.publicState,
    required this.topic,
  });

  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
  final bool LoginCheck = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ink(
          width: 170.w,
          height: 95.h,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Color(0xFFEEF1F4),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: InkWell(
            onTap: () {
              // 나중엔 눌렀을 각 정보를 불러와서 그걸 푸쉬하는 방식으로
              if (LoginCheck){
                context.push(
                  '/group_info',
                  extra: widget.groupName,
                );
              }
              else{ //로그인 화면으로 넘어가는 go_route 푸쉬
                print('로그인 필요 기능');
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Container(
                    // 책사진 넣는 곳
                    width: 40.w,
                    height: 60.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://via.placeholder.com/40x60',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.0.w
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '주제:${widget.topic}', 
                        style: TextStyle(
                          fontSize: 13.sp
                        )
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.groupName, 
                        style: TextStyle(
                          fontSize:15.sp, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(
                        height: 3.h
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.people, 
                            size: 13.w
                          ), // 인원수 아이콘
                          SizedBox(
                            width: 3.w
                          ),
                          Text(
                            '${widget.groupCnt}',
                            style: TextStyle(
                              fontSize: 14.sp
                            )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h
                      ),
                      Text(
                        (widget.publicState == 'PUBLIC') ? '공개':'비공개', 
                        style: TextStyle(
                          fontSize: 13.sp
                        )
                      ),
                    ],
                   ),
                  ),
                ),
              ],
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