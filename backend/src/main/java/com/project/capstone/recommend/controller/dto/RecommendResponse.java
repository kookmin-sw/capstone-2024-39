package com.project.capstone.recommend.controller.dto;

import java.util.List;

public record RecommendResponse (
        List<String> isbnList
) {
}
