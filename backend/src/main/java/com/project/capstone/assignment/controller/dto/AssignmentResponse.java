package com.project.capstone.assignment.controller.dto;

import com.project.capstone.assignment.domain.Assignment;
import com.project.capstone.content.controller.dto.ContentResponse;
import com.project.capstone.content.domain.Content;
import java.util.ArrayList;
import java.util.List;

public record AssignmentResponse(
        Long id,
        String name,
        String startDate,
        String endDate,
        List<ContentResponse> contentList
) {
    public AssignmentResponse(Assignment assignment) {
        this(assignment.getId(), assignment.getName(), assignment.getStartDate(), assignment.getEndDate(), createContentList(assignment.getContents()));
    }

    private static List<ContentResponse> createContentList(List<Content> contents) {
        List<ContentResponse> contentResponseList = new ArrayList<>();
        for (Content content : contents) {
            contentResponseList.add(new ContentResponse(content));
        }
        return contentResponseList;
    }
}
