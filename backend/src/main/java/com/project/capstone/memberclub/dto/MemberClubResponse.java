package com.project.capstone.memberclub.dto;

import com.project.capstone.memberclub.domain.MemberClub;

public record MemberClubResponse(
        Long clubId,
        String name
) {
    public MemberClubResponse(MemberClub memberClub) {
        this(memberClub.getClub().getId(), memberClub.getClub().getName());
    }
}
