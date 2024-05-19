package com.project.capstone.post.controller.dto;

import com.project.capstone.comment.controller.dto.CommentResponse;
import com.project.capstone.comment.domain.Comment;
import com.project.capstone.post.domain.Post;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Builder
public record PostResponse(
        Long id,
        String writer,
        Long clubId,
        String title,
        String body,
        boolean isSticky,
        LocalDateTime createdAt,
        List<CommentResponse> commentResponseList

) {
    public PostResponse(Post post) {
        this(post.getId(), post.getMember().getName(), post.getClub().getId(), post.getTitle(), post.getBody(), post.isSticky(), post.getCreatedAt(), createCommentResponseList(post.getComments()));
    }

    private static List<CommentResponse> createCommentResponseList(List<Comment> commentList) {
        List<CommentResponse> commentResponseList = new ArrayList<>();
        for (Comment comment : commentList) {
            commentResponseList.add(new CommentResponse(comment));
        }
        return commentResponseList;
    }

}
