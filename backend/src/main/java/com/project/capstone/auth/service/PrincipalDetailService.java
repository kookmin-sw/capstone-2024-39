package com.project.capstone.auth.service;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PrincipalDetailService implements UserDetailsService {
    private final MemberRepository memberRepository;
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Member member = memberRepository.findMemberByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("이메일이 존재하지 않습니다."));
        return new PrincipalDetails(member);
    }
}
