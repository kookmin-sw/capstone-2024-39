package com.project.capstone.book.controller.dto;

public record AddBookRequest(
        String isbn,
        String title,
        String author,
        String publisher,
        String publishDate,
        String imageUrl
) {
}
