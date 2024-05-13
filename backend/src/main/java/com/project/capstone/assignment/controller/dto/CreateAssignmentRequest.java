package com.project.capstone.assignment.controller.dto;

import com.project.capstone.assignment.domain.AssignmentType;

public record CreateAssignmentRequest(
        String name,
        AssignmentType type,
        String startDate,
        String endDate
) {
}
