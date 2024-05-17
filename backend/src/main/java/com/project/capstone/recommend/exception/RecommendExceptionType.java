package com.project.capstone.recommend.exception;

import com.project.capstone.common.exception.ExceptionType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.FORBIDDEN;

@AllArgsConstructor
public enum RecommendExceptionType implements ExceptionType {
    INVALID_REQUEST(BAD_REQUEST, 200, "유효하지 않은 임베딩 요청입니다."),
    COMMUNICATION_FAIL(FORBIDDEN, 201, "서버와 통신이 실패했습니다.")
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
