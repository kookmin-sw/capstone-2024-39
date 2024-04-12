package com.project.capstone.auth.service;

import com.project.capstone.auth.controller.dto.SignupRequest;
import com.project.capstone.auth.controller.dto.TokenResponse;
import com.project.capstone.auth.jwt.JwtProvider;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class AuthService {

    private final MemberRepository memberRepository;
    private final JwtProvider jwtProvider;
    public void signup(SignupRequest request) {
        if (memberRepository.findMemberByEmail(request.email()).isPresent()) {
            throw new RuntimeException("이메일이 이미 존재합니다.");
        }
        memberRepository.save(new Member(request));
    }
    @Transactional
    public TokenResponse login(String email) {
        Member member = memberRepository.findMemberByEmail(email)
                .orElseThrow(() -> new RuntimeException("이메일이 존재하지 않습니다."));
        return new TokenResponse(generateToken(member));
    }

    private String generateToken(Member member) {
        return jwtProvider.generate(member.getEmail());
    }
}
