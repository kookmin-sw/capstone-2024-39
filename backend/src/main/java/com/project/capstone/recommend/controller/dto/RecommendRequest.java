package com.project.capstone.recommend.controller.dto;

import java.util.List;

public record RecommendRequest (
        List<String> isbnList
) {
}
