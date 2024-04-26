package com.project.capstone.member.controller.dto;

import com.project.capstone.mybook.domain.MyBook;

public record MyBookResponse(
        Long id,
        String title,
        String author,
        String publisher
) {
    public MyBookResponse(MyBook myBook) {
        this(myBook.getId(), myBook.getBook().getTitle(), myBook.getBook().getAuthor(), myBook.getBook().getPublisher());
    }
}
