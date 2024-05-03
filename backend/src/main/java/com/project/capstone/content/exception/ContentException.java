package com.project.capstone.content.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class ContentException extends BaseException {
    public ContentException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
