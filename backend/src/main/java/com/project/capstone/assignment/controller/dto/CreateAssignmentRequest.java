package com.project.capstone.assignment.controller.dto;

public record CreateAssignmentRequest(
        String name,
        String startDate,
        String endDate
) {
}
