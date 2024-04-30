package com.project.capstone.common.exception;

public record ExceptionResponse (
        int exceptionCode,
        String message
) {

}

