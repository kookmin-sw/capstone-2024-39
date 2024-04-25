package com.project.capstone.member.service;

import com.project.capstone.member.controller.dto.MemberResponse;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {
    private final MemberRepository memberRepository;

    public MemberResponse getMember(UUID id) {
        Member member = memberRepository.findMemberById(id).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        return new MemberResponse(member);
    }
}
