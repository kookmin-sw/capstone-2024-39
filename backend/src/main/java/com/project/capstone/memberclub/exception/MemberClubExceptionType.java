package com.project.capstone.memberclub.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.*;


@AllArgsConstructor
public enum MemberClubExceptionType implements ExceptionType {
    ALREADY_JOIN(BAD_REQUEST, 301, "이미 가입한 모임입니다."),
    MEMBERCLUB_NOT_FOUND(NOT_FOUND, 302, "위임 또는 추방하려는 멤버가 모임 구성원이 아닙니다.");
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
