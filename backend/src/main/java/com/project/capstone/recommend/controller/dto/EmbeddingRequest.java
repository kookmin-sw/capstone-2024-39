package com.project.capstone.recommend.controller.dto;

public record EmbeddingRequest (
        String isbn,
        String title,
        String description
) {
}
