package com.project.capstone.content.controller.dto;

import com.project.capstone.content.domain.ContentType;

public record ContentCreateRequest(
        ContentType contentType,
        String title,
        String body
) {
}
