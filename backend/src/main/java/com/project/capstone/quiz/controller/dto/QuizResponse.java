package com.project.capstone.quiz.controller.dto;

import com.project.capstone.quiz.domain.Quiz;
import com.project.capstone.quiz.domain.QuizType;

import java.util.UUID;

public record QuizResponse (
        Long id,
        UUID memberId,
        Long bookId,
        Long clubId,
        QuizType type,
        String description,
        String answer,
        String example1,
        String example2,
        String example3,
        String example4
) {
    public QuizResponse(Quiz quiz) {
        this(quiz.getId(), quiz.getMember().getId(), quiz.getBook().getId(), quiz.getClub() == null ? null : quiz.getClub().getId(), quiz.getType(),
                quiz.getDescription(), quiz.getAnswer(), quiz.getExample1(), quiz.getExample2(), quiz.getExample3(), quiz.getExample4());
    }
}
