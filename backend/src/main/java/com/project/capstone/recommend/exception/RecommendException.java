package com.project.capstone.recommend.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class RecommendException extends BaseException {

    public RecommendException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
