package com.project.capstone.club.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class ClubException extends BaseException {
    public ClubException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
