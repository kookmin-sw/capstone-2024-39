package com.project.capstone.auth.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class AuthException extends BaseException {
    public AuthException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
