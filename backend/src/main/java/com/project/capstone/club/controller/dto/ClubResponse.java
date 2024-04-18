package com.project.capstone.club.controller.dto;

import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.PublicStatus;

import java.time.LocalDateTime;

public record ClubResponse (
        Long id,
        Long bookId,
        String topic,
        String name,
        LocalDateTime createdAt,
        int maximum,
        PublicStatus publicstatus
) {
    public ClubResponse(Club club) {
        this(club.getId(), club.getBook() == null ? null : club.getBook().getId(), club.getTopic(), club.getName(), club.getCreatedAt(), club.getMaximum(), club.getPublicStatus());
    }
}