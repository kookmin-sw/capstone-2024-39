package com.project.capstone.content.controller.dto;

import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.content.domain.ContentType;

public record ContentCreateRequest(
        AddBookRequest addBookRequest,
        ContentType contentType,
        String title,
        String body,
        String startDate,
        String endDate
) {
}
