package com.project.capstone.member.controller.dto;

import com.project.capstone.mybook.domain.MyBook;

public record MyBookResponse(
        String isbn,
        String title,
        String author,
        String publisher,
        String imageUrl,
        String groupName
) {
    public MyBookResponse(MyBook myBook) {
        this(myBook.getBook().getIsbn(), myBook.getBook().getTitle(), myBook.getBook().getAuthor(),
                myBook.getBook().getPublisher(), myBook.getBook().getImageUrl(), myBook.getGroupName());
    }
}
