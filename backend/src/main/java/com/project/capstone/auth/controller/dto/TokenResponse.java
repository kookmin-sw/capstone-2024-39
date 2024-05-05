package com.project.capstone.auth.controller.dto;

import java.util.UUID;

public record TokenResponse(
        String token,
        UUID id
) {
}
