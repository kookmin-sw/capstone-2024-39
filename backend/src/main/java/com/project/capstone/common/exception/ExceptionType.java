package com.project.capstone.common.exception;

import org.springframework.http.HttpStatus;

public interface ExceptionType {
    HttpStatus httpStatus();
    int exceptionCode();
    String message();
}
