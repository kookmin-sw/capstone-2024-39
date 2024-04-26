package com.project.capstone.member.controller.dto;

import java.time.LocalDateTime;

public record AddMyBookRequest (
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
