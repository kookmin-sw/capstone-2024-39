package com.project.capstone.memberclub.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class MemberClubException extends BaseException {
    public MemberClubException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
