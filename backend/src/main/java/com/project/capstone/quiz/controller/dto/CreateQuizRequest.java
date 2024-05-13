package com.project.capstone.quiz.controller.dto;

import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.quiz.domain.QuizType;

public record CreateQuizRequest(

        AddBookRequest addBookRequest,
        QuizType type,
        String description,
        String answer,
        String example1,
        String example2,
        String example3,
        String example4
) {
}
