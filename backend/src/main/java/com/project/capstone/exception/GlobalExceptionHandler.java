package com.project.capstone.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionResponse;
import com.project.capstone.common.exception.ExceptionType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler
    public ResponseEntity<ExceptionResponse> handleBaseException(BaseException e) {
        ExceptionType type = e.getExceptionType();
        return ResponseEntity.status(type.httpStatus()).body(new ExceptionResponse(type.exceptionCode(), type.message()));
    }

}
