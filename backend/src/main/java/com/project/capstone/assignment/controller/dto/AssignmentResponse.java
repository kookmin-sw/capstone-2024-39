package com.project.capstone.assignment.controller.dto;

import com.project.capstone.assignment.domain.Assignment;
import com.project.capstone.content.controller.dto.ContentResponse;
import com.project.capstone.content.domain.Content;
import com.project.capstone.quiz.controller.dto.QuizResponse;
import com.project.capstone.quiz.domain.Quiz;

import java.util.ArrayList;
import java.util.List;

public record AssignmentResponse(
        Long id,
        String name,
        String startDate,
        String endDate,
        List<ContentResponse> contentList,
        List<QuizResponse> quizList
) {
    public AssignmentResponse(Assignment assignment) {
        this(assignment.getId(), assignment.getName(), assignment.getStartDate(),
                assignment.getEndDate(), createContentList(assignment.getContents()), createQuizList(assignment.getQuizzes()));
    }

    private static List<ContentResponse> createContentList(List<Content> contents) {
        List<ContentResponse> contentResponseList = new ArrayList<>();
        for (Content content : contents) {
            contentResponseList.add(new ContentResponse(content));
        }
        return contentResponseList;
    }

    private static List<QuizResponse> createQuizList(List<Quiz> quizzes) {
        List<QuizResponse> quizResponseList = new ArrayList<>();
        for (Quiz quiz : quizzes) {
            quizResponseList.add(new QuizResponse(quiz));
        }
        return quizResponseList;
    }
}
