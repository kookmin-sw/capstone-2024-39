package com.project.capstone.assignment.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class AssignmentException extends BaseException {
    public AssignmentException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
