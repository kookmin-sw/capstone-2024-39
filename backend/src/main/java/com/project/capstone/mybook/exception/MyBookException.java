package com.project.capstone.mybook.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class MyBookException extends BaseException {
    public MyBookException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
