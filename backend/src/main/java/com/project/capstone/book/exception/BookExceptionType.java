package com.project.capstone.book.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.NOT_FOUND;

@AllArgsConstructor
public enum BookExceptionType implements ExceptionType {

    BOOK_NOT_FOUND(NOT_FOUND, 801, "해당 책을 찾을 수 없습니다."),
    ALREADY_EXIST_BOOK(BAD_REQUEST, 802, "이미 해당 책이 존재합니다.")
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
