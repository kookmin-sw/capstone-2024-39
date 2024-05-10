package com.project.capstone.club.controller.dto;

import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.PublicStatus;

public record SimpleClubResponse(
        Long id,
        String topic,
        String name,
        int memberCnt,
        int maximum,
        PublicStatus publicStatus
        // String imageUrl
) {
    public SimpleClubResponse(Club club) {
        this(club.getId(), club.getTopic(), club.getName(), club.getMembers().size(), club.getMaximum(), club.getPublicStatus());
    }
}
