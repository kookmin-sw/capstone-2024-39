package com.project.capstone.quiz.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@AllArgsConstructor
public enum QuizExceptionType implements ExceptionType {
    QUIZ_NOT_FOUND(NOT_FOUND, 701, "해당 퀴즈를 찾을 수 없습니다.")
    ;

    private final HttpStatus status;
    private final int exceptionCode;
    private final String message;

    @Override
    public HttpStatus httpStatus() {
        return status;
    }

    @Override
    public int exceptionCode() {
        return exceptionCode;
    }

    @Override
    public String message() {
        return message;
    }
}
