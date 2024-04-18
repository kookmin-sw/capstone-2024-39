package com.project.capstone.auth.service;

import com.project.capstone.auth.controller.dto.SignupRequest;
import com.project.capstone.auth.controller.dto.TokenResponse;
import com.project.capstone.auth.exception.AuthException;
import com.project.capstone.auth.jwt.JwtProvider;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import static com.project.capstone.auth.exception.AuthExceptionType.*;

@RequiredArgsConstructor
@Service
public class AuthService {

    private final MemberRepository memberRepository;
    private final JwtProvider jwtProvider;
    public void signup(SignupRequest request) {
        if (memberRepository.findMemberByEmail(request.email()).isPresent()) {
            throw new AuthException(ALREADY_EMAIL_EXIST);
        }
        memberRepository.save(new Member(request));
    }
    @Transactional
    public TokenResponse login(String email) {
        Member member = memberRepository.findMemberByEmail(email)
                .orElseThrow(() -> new AuthException(EMAIL_NOT_FOUND));
        return new TokenResponse(generateToken(member));
    }

    private String generateToken(Member member) {
        return jwtProvider.generate(member.getId().toString());
    }
}
