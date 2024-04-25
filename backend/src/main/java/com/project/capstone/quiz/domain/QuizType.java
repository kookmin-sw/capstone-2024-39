package com.project.capstone.quiz.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.project.capstone.club.domain.PublicStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum QuizType {
    MultipleChoice("객관식"),
    ShortAnswer("단답식"),
    OX("OX")
    ;

    private final String type;

    @JsonCreator(mode = JsonCreator.Mode.DELEGATING)
    public static QuizType from(String type) {
        for (QuizType quizType : QuizType.values()) {
            if (quizType.getType().equals(type)) {
                return quizType;
            }
        }
        throw new RuntimeException("잘못된 퀴즈 타입 입니다.");
    }
}
