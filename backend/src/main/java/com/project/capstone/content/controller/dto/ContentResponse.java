package com.project.capstone.content.controller.dto;

import com.project.capstone.content.domain.Content;
import com.project.capstone.content.domain.ContentType;

import java.util.UUID;

public record ContentResponse(
        Long id,
        UUID memberId,
        Long bookId,
        Long clubId,
        ContentType type,
        String title,
        String body,
        int likes
) {
    public ContentResponse(Content content) {
        this(content.getId(), content.getMember().getId(), content.getBook().getId(),
                content.getClub() == null ? null : content.getClub().getId(), content.getType(), content.getTitle(), content.getBody(), content.getLikes());
    }
}
