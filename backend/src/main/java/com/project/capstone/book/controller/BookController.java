package com.project.capstone.book.controller;

import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.book.service.BookService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
}
