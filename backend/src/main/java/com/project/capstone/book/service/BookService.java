package com.project.capstone.book.service;

import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.book.domain.Book;
import com.project.capstone.book.domain.BookRepository;
import com.project.capstone.book.exception.BookException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import static com.project.capstone.book.exception.BookExceptionType.ALREADY_EXIST_BOOK;

@Service
@RequiredArgsConstructor
@Slf4j
public class BookService {
    private final BookRepository bookRepository;
    public void addBook(AddBookRequest request) {
        if (bookRepository.findBookByIsbn(request.isbn()).isPresent()) {
            throw new BookException(ALREADY_EXIST_BOOK);
        }
        bookRepository.save(new Book(request));
    }
}
