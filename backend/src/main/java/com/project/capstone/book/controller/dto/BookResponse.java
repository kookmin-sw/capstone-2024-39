package com.project.capstone.book.controller.dto;

import com.project.capstone.book.domain.Book;

public record BookResponse(
        Long id,
        String isbn,
        String title,
        String author,
        String publisher
) {
    public BookResponse(Book book) {
        this(book.getId(), book.getIsbn(), book.getTitle(), book.getAuthor(), book.getPublisher());
    }
}
