package com.project.capstone.auth.controller.dto;

import com.project.capstone.member.domain.Gender;

public record SignupRequest(
        String email,
        String name,
        int age,
        Gender gender
) {
}
