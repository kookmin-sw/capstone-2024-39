package com.project.capstone.member.controller.dto;

import com.project.capstone.member.domain.Gender;
import com.project.capstone.memberclub.domain.MemberClub;

import java.util.UUID;

public record SimpleMemberResponse(
        UUID id,
        String name,
        Gender gender
) {
    public SimpleMemberResponse(MemberClub memberClub) {
        this(memberClub.getMember().getId(), memberClub.getMember().getName(), memberClub.getMember().getGender());
    }
}
