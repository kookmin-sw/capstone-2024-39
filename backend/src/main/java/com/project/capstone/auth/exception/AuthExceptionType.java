package com.project.capstone.auth.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.*;

@AllArgsConstructor
public enum AuthExceptionType implements ExceptionType {
    ALREADY_EMAIL_EXIST(BAD_REQUEST, 1000, "이메일이 이미 존재합니다."),
    EMAIL_NOT_FOUND(NOT_FOUND, 1001, "이메일을 찾을 수 없습니다."),
    SIGNATURE_NOT_FOUND(UNAUTHORIZED, 1002, "서명을 확인하지 못했습니다"),
    SIGNATURE_INVALID(UNAUTHORIZED, 1003, "서명이 올바르지 않습니다."),
    MALFORMED_TOKEN(UNAUTHORIZED, 1004, "토큰의 길이 및 형식이 올바르지 않습니다"),
    EXPIRED_TOKEN(UNAUTHORIZED, 1005, "이미 만료된 토큰입니다"),
    UNSUPPORTED_TOKEN(UNAUTHORIZED, 1006, "지원되지 않는 토큰입니다"),
    INVALID_TOKEN(UNAUTHORIZED, 1007, "토큰이 유효하지 않습니다"),
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
