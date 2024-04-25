package com.project.capstone.content.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@AllArgsConstructor
public enum ContentExceptionType implements ExceptionType {
    CONTENT_NOT_FOUND(NOT_FOUND, 901, "해당 컨텐츠를 찾을 수 없습니다."),
    TYPE_NOT_FOUND(NOT_FOUND, 902, "해당 타입을 찾을 수 없습니다.")
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
