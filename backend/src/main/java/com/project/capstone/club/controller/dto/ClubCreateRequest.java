package com.project.capstone.club.controller.dto;

import com.project.capstone.club.domain.PublicStatus;

public record ClubCreateRequest(
        String topic,
        String name,
        int maximum,
        PublicStatus publicStatus,
        Integer password
) {
}
