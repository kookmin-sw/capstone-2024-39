package com.project.capstone.auth.controller.dto;

public record SignupRequest(
        String email,
        String name,
        int age,
        String gender
) {
}
