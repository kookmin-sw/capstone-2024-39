package com.project.capstone.quiz.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.project.capstone.club.domain.PublicStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum QuizType {
    Multiple_Choice("객관식"),
    Short_Answer("단답식"),
    OX("OX")
    ;

    private final String type;

    @JsonCreator
    public static QuizType from(String type) {
        for (QuizType quizType : QuizType.values()) {
            if (quizType.getType().equals(type)) {
                return quizType;
            }
        }
        throw new RuntimeException("잘못된 퀴즈 타입 입니다.");
    }
}
