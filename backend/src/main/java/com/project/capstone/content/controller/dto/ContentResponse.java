package com.project.capstone.content.controller.dto;

import com.project.capstone.book.controller.dto.BookResponse;
import com.project.capstone.content.domain.Content;
import com.project.capstone.content.domain.ContentType;

import java.util.UUID;

public record ContentResponse(
        Long id,
        String writer,
        BookResponse book,
        Long clubId,
        ContentType type,
        String title,
        String body,
        int likes
) {
    public ContentResponse(Content content) {
        this(content.getId(), content.getMember().getName(), new BookResponse(content.getBook()),
                content.getClub() == null ? null : content.getClub().getId(), content.getType(), content.getTitle(), content.getBody(), content.getLikes());
    }
}
