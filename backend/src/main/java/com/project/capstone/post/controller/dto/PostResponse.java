package com.project.capstone.post.controller.dto;

import com.project.capstone.comment.domain.Comment;
import com.project.capstone.post.domain.Post;

import java.util.List;
import java.util.UUID;

public record PostResponse(
        Long id,
        UUID memberId,
        Long clubId,
        String title,
        String body,
        boolean isSticky,
        List<Comment> comments

) {
    public PostResponse(Post post) {
        this(post.getId(), post.getMember().getId(), post.getClub().getId(), post.getTitle(), post.getBody(), post.isSticky(), post.getComments());
    }
}
