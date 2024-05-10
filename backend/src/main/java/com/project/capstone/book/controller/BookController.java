package com.project.capstone.book.controller;

import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.book.controller.dto.BookResponse;
import com.project.capstone.book.service.BookService;
import com.project.capstone.quiz.controller.dto.QuizResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/book")
@RequiredArgsConstructor
public class BookController {

    private final BookService bookService;

    // 책 추가하기
    @PostMapping("/add")
    public ResponseEntity<?> addBook(@RequestBody AddBookRequest request) {
        bookService.addBook(request);
        return ResponseEntity.ok().body("도서 추가 완료");
    }

    // 책 기본 정보 불러오기
    @GetMapping("/search/{isbn}")
    public ResponseEntity<BookResponse> getBook(@PathVariable String isbn) {
        BookResponse bookResponse = bookService.getBookByIsbn(isbn);
        return ResponseEntity.ok(bookResponse);
    }

    // 해당 책의 퀴즈 불러오기
    @GetMapping("/{isbn}/quiz")
    public ResponseEntity<List<QuizResponse>> getQuizByBook(@PathVariable String isbn) {
        List<QuizResponse> quizResponseList = bookService.getQuizByBook(isbn);
        return ResponseEntity.ok(quizResponseList);
    }

    // 해당 책의 컨텐츠 타입별로 불러오기

}
