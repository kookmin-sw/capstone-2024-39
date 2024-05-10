package com.project.capstone.book.service;

import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.book.controller.dto.BookResponse;
import com.project.capstone.book.domain.Book;
import com.project.capstone.book.domain.BookRepository;
import com.project.capstone.book.exception.BookException;
import com.project.capstone.quiz.controller.dto.QuizResponse;
import com.project.capstone.quiz.domain.Quiz;
import com.project.capstone.quiz.domain.QuizRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static com.project.capstone.book.exception.BookExceptionType.ALREADY_EXIST_BOOK;
import static com.project.capstone.book.exception.BookExceptionType.BOOK_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class BookService {
    private final BookRepository bookRepository;
    private final QuizRepository quizRepository;
    public void addBook(AddBookRequest request) {
        if (bookRepository.findBookByIsbn(request.isbn()).isPresent()) {
            throw new BookException(ALREADY_EXIST_BOOK);
        }
        bookRepository.save(new Book(request));
    }

    public BookResponse getBookByIsbn(String isbn) {
        Book book = getBook(isbn);
        return new BookResponse(book);
    }

    public List<QuizResponse> getQuizByBook(String isbn) {
        Book book = getBook(isbn);
        List<Quiz> quizList= quizRepository.findQuizzesByBook(book);
        List<QuizResponse> quizResponseList = new ArrayList<>();
        for (Quiz quiz : quizList) {
            quizResponseList.add(new QuizResponse(quiz));
        }
        return quizResponseList;
    }

    private Book getBook(String isbn) {
        return bookRepository.findBookByIsbn(isbn).orElseThrow(
                () -> new BookException(BOOK_NOT_FOUND)
        );
    }
}
