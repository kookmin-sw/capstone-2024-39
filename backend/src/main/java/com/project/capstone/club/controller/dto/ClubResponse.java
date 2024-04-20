package com.project.capstone.club.controller.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.PublicStatus;
import com.project.capstone.post.domain.Post;

import java.time.LocalDateTime;
import java.util.List;

public record ClubResponse (
        Long id,
        Long bookId,
        String topic,
        String name,
        LocalDateTime createdAt,
        int maximum,
        PublicStatus publicstatus,
        List<Post> posts

) {
    public ClubResponse(Club club) {
        this(club.getId(), club.getBook() == null ? null : club.getBook().getId(), club.getTopic(), club.getName(), club.getCreatedAt(), club.getMaximum(), club.getPublicStatus(), club.getPosts());
    }
}