package com.project.capstone.comment.controller.dto;

import com.project.capstone.comment.domain.Comment;

import java.time.LocalDateTime;
import java.util.UUID;

public record CommentResponse(
        Long id,
        Long postId,
        String writer,
        String body,
        LocalDateTime createdAt
) {
    public CommentResponse(Comment comment) {
        this(comment.getId(), comment.getPost().getId(), comment.getMember().getName(), comment.getBody(), comment.getCreatedAt());
    }
}
