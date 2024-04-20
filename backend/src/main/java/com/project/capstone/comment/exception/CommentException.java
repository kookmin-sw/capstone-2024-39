package com.project.capstone.comment.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class CommentException extends BaseException {
    public CommentException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
