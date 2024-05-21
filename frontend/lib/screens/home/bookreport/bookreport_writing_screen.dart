import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/http.dart';
import 'package:frontend/provider/secure_storage_provider.dart';
import 'package:frontend/screens/home/bookreport/booksearch_screen_util.dart'
    as searchutil;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BookReportWritingScreen extends StatefulWidget {
  const BookReportWritingScreen({
    super.key,
    required this.index,
    required this.clubId,
    required this.asId,
  });

  final int index;
  final dynamic clubId;
  final dynamic asId;

  @override
  State<BookReportWritingScreen> createState() => _BookReportWritingState();
}

class _BookReportWritingState extends State<BookReportWritingScreen> {
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
  final TextEditingController _answerController1 = TextEditingController();
  final TextEditingController _answerController2 = TextEditingController();
  final TextEditingController _answerController3 = TextEditingController();
  final TextEditingController _answerController4 = TextEditingController();
  var token;
  List<dynamic> BookData = [];
  String _author = "작가";
  String _publisher = "출판사";
  String _isbn = "";
  String _publisherDate = "";
  String _imageUrl = "";
  String _description = "";
  List<TmpBook> _books = [];
  bool _isTmp = false;

  late final _KeyboardVisibilityObserverWrapper
      _keyboardVisibilityObserverWrapper;

  @override
  void initState() {
    super.initState();

    _initUserState();
    _loadBooks();
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

  @override
  void dispose() {
    // Remove the keyboard visibility listener
    WidgetsBinding.instance.removeObserver(_keyboardVisibilityObserverWrapper);
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    List<TmpBook> books = await SecureStorageUtil.loadBooks();
    setState(() {
      _books = books;
      if (widget.index < _books.length) {
        final book = _books[widget.index];
        _titleController.text = book.title;
        _bookTitleController.text = book.booktitle;
        _startDate = book.startDate;
        _endDate = book.endDate;
        _template = book.template;
        _author = book.author;
        _publisher = book.publisher;
        _writingController.text = book.writing;
        _isTmp = true;
        print(_template);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(_template),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
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
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    const Text('제목: '),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        //width: _screenWidth * 0.7,
                        child: TextField(
                          style: TextStyle(fontSize: 14.sp),
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: '제목을 입력하세요.',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    const Text('독서 기간: ',
                        style: TextStyle(color: Colors.black)),
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
                            EdgeInsets.symmetric(horizontal: 5.w)),
                      ),
                      child: Text(_startDate.toString().substring(0, 10)),
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
                            EdgeInsets.symmetric(horizontal: 5.w)),
                      ),
                      child: Text(_endDate.toString().substring(0, 10)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.w,
                      color: const Color(0xFFA9AFB7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    const Text('도서: '),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        //width: _screenWidth * 0.7,
                        child: TextField(
                          style: TextStyle(fontSize: 14.sp),
                          controller: _bookTitleController,
                          decoration: const InputDecoration(
                            hintText: '도서를 입력하세요.',
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
                                        for (int i = 0;
                                            i < BookData.length;
                                            i++)
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
                                                _author =
                                                    selectedData['author'];
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
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text('$_author  |  $_publisher',
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            padding: EdgeInsets.all(20.w),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_isTmp) {
                        await SecureStorageUtil.deleteBook(widget.index);
                      }
                      TmpBook newBook = TmpBook(
                        title: _titleController.text,
                        imageUrl: _imageUrl,
                        startDate: _startDate,
                        endDate: _endDate,
                        template: _template,
                        booktitle: _bookTitleController.text,
                        author: _author,
                        publisher: _publisher,
                        writing: _writingController.text,
                      );
                      await SecureStorageUtil.addBook(newBook);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('임시저장 되었습니다.')),
                      );
                      context.pop(true);
                    },
                    child: const Text('임시저장'),
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () async {
                      // 글 저장 기능 추가
                      if (_isTmp) {
                        SecureStorageUtil.deleteBook(widget.index);
                      }
                      //과제 일 때
                      if (_template != '퀴즈') {
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
                      } else {
                        // print(selectedCategory);
                        // print(_answerController.text);
                        switch (selectedCategory) {
                          case "객관식":
                            var ansnum;
                            for (int i = 0; i < _multipleanswer.length; i++) {
                              if (_multipleanswer[i]) {
                                ansnum = i + 1;
                                break;
                              }
                            }
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
                                _answerController1.text,
                                _answerController2.text,
                                _answerController3.text,
                                _answerController4.text,
                                _startDate.toString(),
                                _endDate.toString());
                            break;
                          case "O/X":
                            print(selectedCategory);
                            print(_isOX);
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
                            break;
                          case "단답형":
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
                            break;
                          default:
                        }
                      }
                      context.pop(true);
                    },
                    child: const Text('저장'),
                  ),
                ],
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
          style: TextStyle(fontSize: 14.sp),
          controller: _writingController,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: '자유롭게 글을 작성해주세요.',
            border: InputBorder.none,
          ),
        );
      case "한줄평":
        return TextField(
          style: TextStyle(fontSize: 14.sp),
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
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: TextField(
                  controller: _writingController,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: '인용문을 작성해주세요',
                    hintStyle: TextStyle(
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.17,
                  ),
                ),
                SizedBox(width: 3.w),
                SizedBox(
                  width: 121,
                  height: 22,
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 0,
                    ),
                    underline: Container(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
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
              height: 190.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 350.w,
                      height: 190.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(width: 1.w),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        const Text('Q: '),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            //width: _screenWidth * 0.7,
                            child: TextField(
                              style: TextStyle(fontSize: 14.sp),
                              controller: _questionController,
                              decoration: const InputDecoration(
                                hintText: '질문을 입력해주세요.',
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  const Text('A: '),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      //width: _screenWidth * 0.7,
                      child: TextField(
                        style: TextStyle(fontSize: 14.sp),
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: '답을 입력해주세요.',
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
              height: 190.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 350.w,
                      height: 190.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(width: 1.w),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        const Text('Q: '),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            //width: _screenWidth * 0.7,
                            child: TextField(
                              style: TextStyle(fontSize: 14.sp),
                              controller: _questionController,
                              decoration: const InputDecoration(
                                hintText: '질문을 입력해주세요.',
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
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
                      elevation: 0,
                      side: BorderSide(width: 0.5.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      minimumSize: const Size(140, 140),
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
                      elevation: 0,
                      side: BorderSide(width: 0.5.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      minimumSize: const Size(140, 140),
                    ),
                    child: const Text('X'),
                  ),
                ],
              ),
            ),
          ],
        );
      case ("객관식"):
        return Column(
          children: [
            SizedBox(
              width: 350.w,
              height: 190.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 350.w,
                      height: 190.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7FFEB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(width: 1.w),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        const Text('Q: '),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            //width: _screenWidth * 0.7,
                            child: TextField(
                              style: TextStyle(fontSize: 14.sp),
                              controller: _questionController,
                              decoration: const InputDecoration(
                                hintText: '질문을 입력해주세요.',
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
                                padding: EdgeInsets.all(0.w),
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
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5.w,
                                  ),
                                  color: _multipleanswer[i]
                                      ? Colors.green
                                      : Colors.white,
                                ),
                                height: 24.h,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10.w),
                                    const Text('A: '),
                                    Expanded(
                                      child: SizedBox(
                                        //width: _screenWidth * 0.7,
                                        child: TextField(
                                          style: TextStyle(fontSize: 10.sp),
                                          controller: _answerController1,
                                          decoration: InputDecoration(
                                            hintText: '답을 입력해주세요.',
                                            contentPadding:
                                                EdgeInsets.all(10.w),
                                            border: InputBorder.none,
                                          ),
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
