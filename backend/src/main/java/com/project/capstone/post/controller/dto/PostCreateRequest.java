package com.project.capstone.post.controller.dto;

import java.util.UUID;

public record PostCreateRequest(
        String title,
        String body,
        boolean isSticky
) {
}
