package com.project.capstone.member.service;

import com.project.capstone.member.controller.dto.MemberResponse;
import com.project.capstone.member.controller.dto.MyBookResponse;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.mybook.domain.MyBook;
import com.project.capstone.mybook.domain.MyBookRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {
    private final MemberRepository memberRepository;
    private final MyBookRepository myBookRepository;


    public MemberResponse getMember(UUID id) {
        Member member = memberRepository.findMemberById(id).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        return new MemberResponse(member);
    }

    public List<MyBookResponse> getMyBooks(String userId) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        List<MyBook> myBooksByMember = myBookRepository.findMyBooksByMember(member);
        List<MyBookResponse> books = new ArrayList<>();
        for (MyBook book : myBooksByMember) {
            books.add(new MyBookResponse(book));
        }
        return books;
    }
}
