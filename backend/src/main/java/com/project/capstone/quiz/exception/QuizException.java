package com.project.capstone.quiz.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class QuizException extends BaseException {
    public QuizException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
