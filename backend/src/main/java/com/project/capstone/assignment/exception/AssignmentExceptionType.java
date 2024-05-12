package com.project.capstone.assignment.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.NOT_FOUND;

@AllArgsConstructor
public enum AssignmentExceptionType implements ExceptionType {
    ASSIGNMENT_NOT_FOUND(NOT_FOUND, 601, "해당 과제를 찾을 수 없습니다."),
    NOT_EXIST_BOOK(BAD_REQUEST, 602, "대표책이 지정되지 않았습니다.")
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
