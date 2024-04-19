package com.project.capstone.member.exception;

import com.project.capstone.common.exception.BaseException;
import com.project.capstone.common.exception.ExceptionType;

public class MemberException extends BaseException {
    public MemberException(ExceptionType exceptionType) {
        super(exceptionType);
    }
}
