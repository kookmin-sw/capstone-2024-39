package com.project.capstone.member.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.project.capstone.quiz.domain.QuizType;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum Gender {
    MALE("남자"),
    FEMALE("여자")
    ;
    private final String type;

    @JsonCreator(mode = JsonCreator.Mode.DELEGATING)
    public static Gender from(String type) {
        for (Gender gender: Gender.values()) {
            if (gender.getType().equals(type)) {
                return gender;
            }
        }
        throw new RuntimeException("잘못된 성별 입니다.");
    }
}
