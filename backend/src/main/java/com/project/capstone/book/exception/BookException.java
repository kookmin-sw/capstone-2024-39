package com.project.capstone.book.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class BookException extends BaseException {
    public BookException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
