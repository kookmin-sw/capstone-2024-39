package com.project.capstone.content.service;

import com.project.capstone.assignment.domain.Assignment;
import com.project.capstone.assignment.domain.AssignmentRepository;
import com.project.capstone.assignment.exception.AssignmentException;
import com.project.capstone.assignment.exception.AssignmentExceptionType;
import com.project.capstone.book.domain.Book;
import com.project.capstone.book.domain.BookRepository;
import com.project.capstone.book.exception.BookException;
import com.project.capstone.book.exception.BookExceptionType;
import com.project.capstone.book.service.BookService;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.club.exception.ClubException;
import com.project.capstone.club.exception.ClubExceptionType;
import com.project.capstone.content.controller.dto.ContentCreateRequest;
import com.project.capstone.content.controller.dto.ContentResponse;
import com.project.capstone.content.domain.Content;
import com.project.capstone.content.domain.ContentRepository;
import com.project.capstone.content.domain.ContentType;
import com.project.capstone.content.exception.ContentException;
import com.project.capstone.content.exception.ContentExceptionType;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.member.exception.MemberExceptionType;
import com.project.capstone.recommend.controller.dto.EmbeddingRequest;
import com.project.capstone.recommend.service.RecommendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import static com.project.capstone.assignment.exception.AssignmentExceptionType.*;
import static com.project.capstone.book.exception.BookExceptionType.BOOK_NOT_FOUND;
import static com.project.capstone.club.exception.ClubExceptionType.CLUB_NOT_FOUND;
import static com.project.capstone.content.exception.ContentExceptionType.CONTENT_NOT_FOUND;
import static com.project.capstone.content.exception.ContentExceptionType.TYPE_NOT_FOUND;
import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContentService {

    private final ContentRepository contentRepository;
    private final BookRepository bookRepository;
    private final ClubRepository clubRepository;
    private final MemberRepository memberRepository;
    private final AssignmentRepository assignmentRepository;
    private final RecommendService recommendService;

    public void createContent(String userId, ContentCreateRequest request, Long clubId, Long asId) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );

        Book book = bookRepository.findBookByIsbn(request.addBookRequest().isbn()).orElse(null);
        if (book == null) {
            recommendService.embed(new EmbeddingRequest(request.addBookRequest().isbn(), request.addBookRequest().title(), request.addBookRequest().description()));
            book = bookRepository.save(new Book(request.addBookRequest()));
        }

        Club club;
        if (clubId == null) {
            club = null;
        }
        else {
            club = clubRepository.findClubById(clubId).orElseThrow(
                    () -> new ClubException(CLUB_NOT_FOUND)
            );
            if (club.getBook() == null) {
                throw new AssignmentException(NOT_EXIST_BOOK);
            }
        }

        Assignment assignment;
        if (asId == null) {
            assignment = null;
        }
        else {
            assignment = assignmentRepository.findAssignmentById(asId).orElseThrow(
                    () -> new AssignmentException(ASSIGNMENT_NOT_FOUND)
            );
            if (!assignment.getAssignmentType().toString().equals(request.contentType().toString())) {
                throw new AssignmentException(NOT_MATCH_TYPE);
            }
        }

        Content saved = contentRepository.save(new Content(request, member, book, club, assignment));
        member.getContents().add(saved);
        book.getContents().add(saved);

        if (assignment != null) {
            assignment.getContents().add(saved);
        }
        if (club != null) {
            club.getContents().add(saved);
        }
    }

    public ContentResponse getContent(Long id) {
        Content content = contentRepository.findContentById(id).orElseThrow(
                () -> new ContentException(CONTENT_NOT_FOUND)
        );

        return new ContentResponse(content);
    }

    public List<ContentResponse> getContents(String type, Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );

        for (ContentType contentType : ContentType.values()) {
            if (contentType.equals(ContentType.valueOf(type))) {
                List<Content> contentsByTypeAndClub = contentRepository.findContentsByTypeAndClub(ContentType.valueOf(type), club);
                return contentsByTypeAndClub.stream()
                        .map(ContentResponse::new)
                        .toList();
            }
        }
        throw new ContentException(TYPE_NOT_FOUND);
    }
}
