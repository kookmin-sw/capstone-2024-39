package com.project.capstone.club.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum PublicStatus {
    PUBLIC("공개"),
    PRIVATE("비공개");

    private final String description;


    @JsonCreator(mode = JsonCreator.Mode.DELEGATING)
    public static PublicStatus from(String status) {
        for (PublicStatus publicStatus : PublicStatus.values()) {
            if (publicStatus.getDescription().equals(status)) {
                return publicStatus;
            }
        }
        throw new RuntimeException("잘못된 공개 여부입니다.");
    }
}
