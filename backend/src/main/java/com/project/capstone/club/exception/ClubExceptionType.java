package com.project.capstone.club.exception;

import com.project.capstone.common.exception.ExceptionType;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;


import static org.springframework.http.HttpStatus.*;

@AllArgsConstructor
public enum ClubExceptionType implements ExceptionType {

    CLUB_NOT_FOUND(NOT_FOUND, 101, "해당 모임을 찾을 수 없습니다."),
    EXIT_WITHOUT_DELEGATION(BAD_REQUEST, 102, "모임장은 위임 후 모임을 나갈 수 있습니다."),
    UNAUTHORIZED_ACTION(UNAUTHORIZED, 103, "모임장만 할 수 있는 기능입니다.")
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
