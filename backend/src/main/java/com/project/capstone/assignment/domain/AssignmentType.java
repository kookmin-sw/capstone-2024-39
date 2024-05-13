package com.project.capstone.assignment.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

@AllArgsConstructor
@Getter
@Slf4j
public enum AssignmentType {

    Review("독후감"),
    Quotation("인용구"),
    ShortReview("한줄평"),
    Quiz("퀴즈")
    ;

    private final String type;

    @JsonCreator(mode = JsonCreator.Mode.DELEGATING)
    public static AssignmentType from(String type) {
        for (AssignmentType assignmentType : AssignmentType.values()) {
            if (assignmentType.getType().equals(type)) {
                return assignmentType;
            }
        }
        throw new RuntimeException("잘못된 과제 타입 입니다.");
    }
}
