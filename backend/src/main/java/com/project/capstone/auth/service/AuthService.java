package com.project.capstone.auth.service;

import com.project.capstone.auth.controller.dto.LoginRequest;
import com.project.capstone.auth.controller.dto.SignupRequest;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class AuthService {

    private final MemberRepository memberRepository;
    public void signup(SignupRequest request) {
        if (memberRepository.findMemberByEmail(request.email()).isPresent()) {
            throw new RuntimeException("이메일이 이미 존재합니다.");
        }
        memberRepository.save(new Member(request));
    }
    public void login(LoginRequest request) {
        if (memberRepository.findMemberByEmail(request.email()).isEmpty()) {
            throw new RuntimeException("이메일이 존재하지 않습니다.");
        }
    }
}
