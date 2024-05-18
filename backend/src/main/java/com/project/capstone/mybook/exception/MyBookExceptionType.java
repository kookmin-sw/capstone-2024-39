package com.project.capstone.mybook.exception;

import com.project.capstone.common.exception.ExceptionType;
import com.project.capstone.mybook.domain.MyBook;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.NOT_FOUND;

@AllArgsConstructor
public enum MyBookExceptionType implements ExceptionType {
    MYBOOK_NOT_FOUND(NOT_FOUND, 2000, "해당 나만의 서재 또는 서재의 책을 찾을 수 없습니다."),
    ALREADY_EXIST_MYBOOK(BAD_REQUEST, 2001, "이미 나만의 서재에 등록된 책 입니다.")
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
