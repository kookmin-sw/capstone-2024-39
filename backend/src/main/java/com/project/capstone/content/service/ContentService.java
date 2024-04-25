package com.project.capstone.content.service;

import com.project.capstone.book.domain.Book;
import com.project.capstone.book.domain.BookRepository;
import com.project.capstone.book.exception.BookException;
import com.project.capstone.book.exception.BookExceptionType;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.club.exception.ClubException;
import com.project.capstone.club.exception.ClubExceptionType;
import com.project.capstone.content.controller.dto.ContentCreateRequest;
import com.project.capstone.content.domain.Content;
import com.project.capstone.content.domain.ContentRepository;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.member.exception.MemberExceptionType;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

import static com.project.capstone.book.exception.BookExceptionType.BOOK_NOT_FOUND;
import static com.project.capstone.club.exception.ClubExceptionType.CLUB_NOT_FOUND;
import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContentService {

    private final ContentRepository contentRepository;
    private final BookRepository bookRepository;
    private final ClubRepository clubRepository;
    private final MemberRepository memberRepository;

    public void createContent(String userId, ContentCreateRequest request, Long bookId, Long clubId) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        Book book = bookRepository.findBookById(bookId).orElseThrow(
                () -> new BookException(BOOK_NOT_FOUND)
        );
        Club club;
        if (clubId == null) {
            club = null;
        }
        else {
            club = clubRepository.findClubById(clubId).orElseThrow(
                    () -> new ClubException(CLUB_NOT_FOUND)
            );
        }
        Content saved = contentRepository.save(
                Content.builder()
                        .type(request.contentType())
                        .title(request.title())
                        .body(request.body())
                        .likes(0)
                        .member(member)
                        .book(book)
                        .club(club)
                        .build()
        );

        member.getContents().add(saved);
        book.getContents().add(saved);
        if (club != null) {
            club.getContents().add(saved);
        }
    }
}
