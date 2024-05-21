import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/bookinfo_provider.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/bookreport/booksearch_screen_util.dart'
    as searchutil;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/env.dart';

class BookReportWritingScreen extends StatefulWidget {
  const BookReportWritingScreen({
    super.key,
    required this.index,
    required this.clubId,
    required this.asId,
    required this.isbn,
    required this.dateInfo,
  });

  final int index;
  final dynamic clubId;
  final dynamic asId;
  final dynamic isbn;
  final dynamic dateInfo;

  @override
  State<BookReportWritingScreen> createState() => _BookReportWritingState();
}

class _BookReportWritingState extends State<BookReportWritingScreen> {
  final double _screenWidth = 0; // State variable to store screen width
  bool _isKeyboardVisible = false;

  // Variables to store user input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _template = "";
  final TextEditingController _writingController = TextEditingController();
  String? selectedCategory = '단답형';
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  bool _isOX = true;
  List<bool> _multipleanswer = [false, false, false, false];
  final List<TextEditingController> _answerControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  var token;
  List<dynamic> BookData = [];
  String _author = "작가";
  String _publisher = "출판사";
  String _isbn = "";
  String _publisherDate = "";
  String _imageUrl = "";
  String _description = "";

  late final _KeyboardVisibilityObserverWrapper
      _keyboardVisibilityObserverWrapper;

  @override
  void initState() {
    super.initState();
    checkHW();

    _initUserState();
    // Initialize _keyboardVisibilityObserver and _keyboardVisibilityObserverWrapper
    final keyboardVisibilityObserver =
        _KeyboardVisibilityObserver((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
    _keyboardVisibilityObserverWrapper =
        _KeyboardVisibilityObserverWrapper(keyboardVisibilityObserver);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      keyboardVisibilityObserver.didChangeMetrics();
    });

    // Add listener for keyboard visibility
    WidgetsBinding.instance.addObserver(_keyboardVisibilityObserverWrapper);
  }

  Future<void> _initUserState() async {
    final secureStorage =
        Provider.of<SecureStorageService>(context, listen: false);
    token = await secureStorage.readData("token");
  }

  void checkHW() async {
    print(widget.isbn);
    print(widget.dateInfo);
    if (widget.isbn != null) {
      var bookInfo = await getBookInfo(widget.isbn);
      print(bookInfo);
      setState(() {
        _bookTitleController.text = bookInfo['title'];
        _author = bookInfo['author'];
        _publisher = bookInfo['publisher'];
        _isbn = widget.isbn;
        _publisherDate = bookInfo['publishDate'];
        _imageUrl = bookInfo['imageUrl'];
      });
    }
    if (widget.dateInfo != null) {
      setState(() {
        _startDate = DateTime.parse(widget.dateInfo['startDate']);
        _endDate = DateTime.parse(widget.dateInfo['endDate']);
      });
    }
  }

  @override
  void dispose() {
    // Remove the keyboard visibility listener
    WidgetsBinding.instance.removeObserver(_keyboardVisibilityObserverWrapper);
    _questionController.dispose();
    _answerController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookInfoProvider = Provider.of<BookInfoProvider>(context);

    if (widget.index != 0 && widget.index < bookInfoProvider.books.length) {
      final book = bookInfoProvider.books[widget.index];
      _bookTitleController.text = book.title;
      _startDate = book.startDate;
      _endDate = book.endDate;
      _template = book.template;
    } else {
      // 책이 없는 경우에 대한 처리
      _template = widget.index == 999
          ? "퀴즈"
          : widget.index == 998
              ? "인용구"
              : widget.index == 997
                  ? "한줄평"
                  : widget.index == 996
                      ? "독후감"
                      : "";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_template),
        titleTextStyle: textStyle(20, Colors.white, true),
        backgroundColor: const Color(0xFF0E9913),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            (_template != '퀴즈')
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          '제목: ',
                          style: textStyle(14, null, false),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            width: _screenWidth * 0.7.w,
                            child: TextField(
                              style: textStyle(14, null, false),
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: '제목을 입력하세요.',
                                hintStyle: textStyle(14, Colors.grey, false),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('독서 기간: ', style: textStyle(14, null, false)),
                  SizedBox(width: 3.w),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 5)),
                    ),
                    child: Text(_startDate.toString().substring(0, 10),
                        style: textStyle(14, null, false)),
                  ),
                  const Text(' ~ '),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _endDate) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 5)),
                    ),
                    child: Text(
                      _endDate.toString().substring(0, 10),
                      style: textStyle(14, null, false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFA9AFB7),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '도서: ',
                    style: textStyle(14, null, false),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: _screenWidth * 0.7,
                      child: TextField(
                        style: textStyle(14, null, false),
                        controller: _bookTitleController,
                        decoration: InputDecoration(
                          hintText: '도서를 입력하세요.',
                          hintStyle: textStyle(14, Colors.grey, false),
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) async {
                          BookData =
                              await SearchBook(_bookTitleController.text);
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('도서 검색 결과'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (int i = 0; i < BookData.length; i++)
                                        searchutil.BookSearchListItem(
                                          data: BookData[i],
                                          type: "search",
                                          clubId: 0,
                                          onSelected: (selectedData) {
                                            print(
                                                'Selected Data: $selectedData');
                                            _bookTitleController.text =
                                                selectedData['title'];
                                            setState(() {
                                              _author = selectedData['author'];
                                              _publisher =
                                                  selectedData['publisher'];
                                            });
                                            _isbn = selectedData['isbn'];
                                            _publisherDate =
                                                selectedData['pubdate'];
                                            _imageUrl = selectedData['image'];
                                            _description =
                                                selectedData['description'];
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('$_author  |  $_publisher',
                      style: textStyle(14, null, false)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.w,
                    color: const Color(0xFFA9AFB7),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTemplateUI(_template),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: !_isKeyboardVisible,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () async {
                // 글 저장 기능 추가
                if (_isFieldEmpty(_bookTitleController)) {
                  _showBookTitleErrorDialog(context);
                } else {
                  if (_template != '퀴즈') {
                    if (_isFieldEmpty(_titleController)) {
                      _showContentTitleErrorDialog(context);
                    } else if (_isFieldEmpty(_writingController)) {
                      _showContentBodyErrorDialog(context);
                    } else {
                      await contentCreate(
                          token,
                          widget.clubId,
                          widget.asId,
                          _isbn,
                          _bookTitleController.text,
                          _description,
                          _author,
                          _publisher,
                          _publisherDate,
                          _imageUrl,
                          _template,
                          _titleController.text,
                          _writingController.text,
                          _startDate.toString(),
                          _endDate.toString());
                      context.pop(true);
                    }
                  } else {
                    switch (selectedCategory) {
                      case "객관식":
                        var ansnum;
                        for (int i = 0; i < _multipleanswer.length; i++) {
                          if (_multipleanswer[i]) {
                            ansnum = i + 1;
                            break;
                          }
                        }
                        if (ansnum == null ||
                            _isFieldEmpty(_questionController)) {
                          _showQADialog(context);
                        } else {
                          await quizCreate(
                              token,
                              widget.clubId,
                              widget.asId,
                              _isbn,
                              _bookTitleController.text,
                              _author,
                              _publisher,
                              _publisherDate,
                              _imageUrl,
                              selectedCategory.toString(),
                              _questionController.text,
                              ansnum,
                              _answerControllers[0].text,
                              _answerControllers[1].text,
                              _answerControllers[2].text,
                              _answerControllers[3].text,
                              _startDate.toString(),
                              _endDate.toString());
                          context.pop(true);
                        }

                        break;
                      case "O/X":
                        if (_isFieldEmpty(_questionController)) {
                          _showQADialog(context);
                        } else {
                          await quizCreate(
                              token,
                              widget.clubId,
                              widget.asId,
                              _isbn,
                              _bookTitleController.text,
                              _author,
                              _publisher,
                              _publisherDate,
                              _imageUrl,
                              "OX",
                              _questionController.text,
                              _isOX ? "O" : "X",
                              null,
                              null,
                              null,
                              null,
                              _startDate.toString(),
                              _endDate.toString());
                          context.pop(true);
                        }
                        break;
                      case "단답형":
                        if (_isFieldEmpty(_questionController) ||
                            _isFieldEmpty(_answerController)) {
                          _showQADialog(context);
                        } else {
                          await quizCreate(
                              token,
                              widget.clubId,
                              widget.asId,
                              _isbn,
                              _bookTitleController.text,
                              _author,
                              _publisher,
                              _publisherDate,
                              _imageUrl,
                              "단답식",
                              _questionController.text,
                              _answerController.text,
                              null,
                              null,
                              null,
                              null,
                              _startDate.toString(),
                              _endDate.toString());
                          context.pop(true);
                        }
                        break;
                      default:
                    }
                  }
                }
              },
              child: Text(
                '저장',
                style: textStyle(13, null, false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateUI(String template) {
    switch (template) {
      case "독후감":
        return TextField(
          style: textStyle(14, null, false),
          controller: _writingController,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: '자유롭게 글을 작성해주세요.',
            border: InputBorder.none,
          ),
        );
      case "한줄평":
        return TextField(
          style: textStyle(14, null, false),
          controller: _writingController,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: '한줄 평을 작성해주세요.',
            border: InputBorder.none,
          ),
        );
      case "인용구":
        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _writingController,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: '인용문을 작성해주세요',
                    hintStyle: TextStyle(
                      // 힌트 텍스트 정중앙 정렬
                      height: 15.h,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              const Positioned(
                left: 0,
                top: 0,
                child: Icon(Icons.format_quote),
              ),
              const Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.format_quote),
              ),
            ],
          ),
        );
      case "퀴즈":
        return Column(
          children: [
            Row(
              children: [
                Text(
                  '카테고리: ',
                  style: textStyle(15, null, false),
                ),
                SizedBox(width: 3.w),
                SizedBox(
                  width: 121.w,
                  height: 22.h,
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: <String>['단답형', '객관식', 'O/X']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: textStyle(14, Colors.black, false),
                    underline: Container(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuizUI(selectedCategory!),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        throw ArgumentError('Invalid template type');
    }
  }

  Widget _buildQuizUI(String quizType) {
    switch (quizType) {
      case ("단답형"):
        return Column(
          children: [
            SizedBox(
              width: 350.w,
              height: 150.h,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7FFEB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1.w),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Q : ',
                          style: textStyle(14, null, true),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            width: _screenWidth * 0.7.w,
                            child: TextField(
                              style: textStyle(14, null, false),
                              controller: _questionController,
                              decoration: InputDecoration(
                                hintText: '질문을 입력해주세요.',
                                hintStyle: textStyle(14, Colors.grey, false),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'A : ',
                    style: textStyle(14, null, true),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      width: _screenWidth * 0.7.w,
                      child: TextField(
                        style: textStyle(14, null, false),
                        controller: _answerController,
                        decoration: InputDecoration(
                          hintText: '답을 입력해주세요.',
                          hintStyle: textStyle(14, Colors.grey, false),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case ("O/X"):
        return Column(
          children: [
            SizedBox(
              width: 350.w,
              height: 150.h,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7FFEB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1.w),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Q : ',
                          style: textStyle(14, null, true),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            width: _screenWidth * 0.7.w,
                            child: TextField(
                              style: textStyle(14, null, false),
                              controller: _questionController,
                              decoration: InputDecoration(
                                hintText: '질문을 입력해주세요.',
                                hintStyle: textStyle(14, Colors.grey, false),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isOX = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: _isOX ? Colors.green : Colors.white,
                    elevation: 1,
                    side: BorderSide(width: 0.5.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(100, 100),
                  ),
                  child: const Text('O'),
                ),
                SizedBox(width: 30.w),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isOX = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: !_isOX ? Colors.green : Colors.white,
                    elevation: 1,
                    side: BorderSide(width: 0.5.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(100, 100),
                  ),
                  child: const Text('X'),
                ),
              ],
            ),
          ],
        );
      case ("객관식"):
        return Column(
          children: [
            SizedBox(
              width: 350.w,
              height: 150.h,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7FFEB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1.w),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Q : ',
                          style: textStyle(14, null, true),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            width: _screenWidth * 0.7.w,
                            child: TextField(
                              style: textStyle(14, null, false),
                              controller: _questionController,
                              decoration: InputDecoration(
                                hintText: '질문을 입력해주세요.',
                                hintStyle: textStyle(14, Colors.grey, false),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Column(
                children: [
                  for (int i = 0; i < 4; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  for (int j = 0; j < 4; j++) {
                                    if (i == j) {
                                      _multipleanswer[j] = true;
                                    } else {
                                      _multipleanswer[j] = false;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                child: _multipleanswer[i]
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const Icon(Icons.check,
                                        color: Colors.grey),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5.w,
                                  ),
                                  color: _multipleanswer[i]
                                      ? Colors.green
                                      : Colors.white,
                                ),
                                height: 30.h,
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10.w),
                                    Text(
                                      'A : ',
                                      style: textStyle(12, null, true),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        style: textStyle(12, null, false),
                                        controller: _answerControllers[i],
                                        decoration: InputDecoration(
                                          hintText: '답을 입력해주세요.',
                                          hintStyle:
                                              textStyle(14, Colors.grey, false),
                                          // contentPadding: EdgeInsets.all(10.w),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );

      default:
        throw ArgumentError('Invalid quiz type');
    }
  }
}

// 질문이나 정답을 설정하지 않은 경우
void _showQADialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('문제 오류'),
        titleTextStyle: textStyle(20, Colors.black, true),
        content: const Text('문제 혹은 정답을 입력해야 합니다.'),
        contentTextStyle: textStyle(14, Colors.black, false),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "확인",
              style: textStyle(13, null, false),
            ),
          ),
        ],
      );
    },
  );
}

// 책을 설정하지 않은 경우
void _showBookTitleErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('책 설정 오류'),
        titleTextStyle: textStyle(20, Colors.black, true),
        content: const Text('책을 설정해야 합니다.'),
        contentTextStyle: textStyle(14, Colors.black, false),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "확인",
              style: textStyle(13, null, false),
            ),
          ),
        ],
      );
    },
  );
}

// 제목을 설정하지 않은 경우
void _showContentTitleErrorDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('제목 오류'),
        titleTextStyle: textStyle(20, Colors.black, true),
        content: const Text('제목을 설정해야 합니다.'),
        contentTextStyle: textStyle(14, Colors.black, false),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "확인",
              style: textStyle(13, null, false),
            ),
          ),
        ],
      );
    },
  );
}

// 글을 입력하지 않은 경우
void _showContentBodyErrorDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('내용 오류'),
        titleTextStyle: textStyle(20, Colors.black, true),
        content: const Text('내용을 입력해야 합니다.'),
        contentTextStyle: textStyle(14, Colors.black, false),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "확인",
              style: textStyle(13, null, false),
            ),
          ),
        ],
      );
    },
  );
}

class _KeyboardVisibilityObserver {
  final Function(bool) onKeyboardVisibilityChanged;

  _KeyboardVisibilityObserver(this.onKeyboardVisibilityChanged);

  void didChangeMetrics() {
    // ignore: deprecated_member_use
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    onKeyboardVisibilityChanged(bottomInset > 0);
  }
}

class _KeyboardVisibilityObserverWrapper extends WidgetsBindingObserver {
  final _KeyboardVisibilityObserver _keyboardVisibilityObserver;

  _KeyboardVisibilityObserverWrapper(this._keyboardVisibilityObserver);

  @override
  void didChangeMetrics() {
    _keyboardVisibilityObserver.didChangeMetrics();
  }
}

bool _isFieldEmpty(TextEditingController controller) {
  return controller.text.trim().isEmpty;
}
