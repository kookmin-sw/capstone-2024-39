package com.project.capstone.book.controller;

public record AddBookRequest(
        String isbn,
        String title,
        String category1d,
        String category2d,
        String category3d,
        String author,
        String publisher,
        String publishDate
) {
}
