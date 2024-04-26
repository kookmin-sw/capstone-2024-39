package com.project.capstone.post.controller.dto;

import com.project.capstone.post.domain.Post;

public record SimplePostResponse(
        Long id,
        String writer,
        Long clubId,
        String title,
        String body,
        boolean isSticky
) {
    public SimplePostResponse(Post post) {
        this(post.getId(), post.getMember().getName(), post.getClub().getId(), post.getTitle(), post.getBody(), post.isSticky());
    }
}
