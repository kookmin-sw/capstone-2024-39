package com.project.capstone.member.controller.dto;

import com.project.capstone.mybook.domain.MyBook;

public record MyBookResponse(
        Long id,
        String isbn,
        String title,
        String author,
        String publisher
) {
    public MyBookResponse(MyBook myBook) {
        this(myBook.getId(), myBook.getBook().getIsbn(), myBook.getBook().getTitle(), myBook.getBook().getAuthor(), myBook.getBook().getPublisher());
    }
}
