package com.project.capstone.auth.service;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PrincipalDetailService implements UserDetailsService {
    private final MemberRepository memberRepository;
    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
        Member member = memberRepository.findMemberById(UUID.fromString(id))
                .orElseThrow(() -> new UsernameNotFoundException("해당 멤버가 존재하지 않습니다."));
        return new PrincipalDetails(member);
    }
}
