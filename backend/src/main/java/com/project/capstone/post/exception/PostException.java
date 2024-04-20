package com.project.capstone.post.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class PostException extends BaseException {
    public PostException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
