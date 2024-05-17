package com.project.capstone.quiz.service;

import com.project.capstone.assignment.domain.Assignment;
import com.project.capstone.assignment.domain.AssignmentRepository;
import com.project.capstone.assignment.exception.AssignmentException;
import com.project.capstone.assignment.exception.AssignmentExceptionType;
import com.project.capstone.book.domain.Book;
import com.project.capstone.book.domain.BookRepository;
import com.project.capstone.book.exception.BookException;
import com.project.capstone.book.exception.BookExceptionType;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.club.exception.ClubException;
import com.project.capstone.club.exception.ClubExceptionType;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.member.exception.MemberExceptionType;
import com.project.capstone.quiz.controller.dto.CreateQuizRequest;
import com.project.capstone.quiz.controller.dto.QuizResponse;
import com.project.capstone.quiz.domain.Quiz;
import com.project.capstone.quiz.domain.QuizRepository;
import com.project.capstone.quiz.exception.QuizException;
import com.project.capstone.quiz.exception.QuizExceptionType;
import com.project.capstone.recommend.controller.dto.EmbeddingRequest;
import com.project.capstone.recommend.service.RecommendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

import static com.project.capstone.assignment.exception.AssignmentExceptionType.*;
import static com.project.capstone.book.exception.BookExceptionType.BOOK_NOT_FOUND;
import static com.project.capstone.club.exception.ClubExceptionType.CLUB_NOT_FOUND;
import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;
import static com.project.capstone.quiz.exception.QuizExceptionType.QUIZ_NOT_FOUND;

@RequiredArgsConstructor
@Service
@Slf4j
public class QuizService {

    private final QuizRepository quizRepository;
    private final MemberRepository memberRepository;
    private final BookRepository bookRepository;
    private final ClubRepository clubRepository;
    private final AssignmentRepository assignmentRepository;
    private final RecommendService recommendService;
    private final static String QUIZ_TYPE = "퀴즈";

    public void createQuiz(String userId, CreateQuizRequest request, Long clubId, Long asId) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );

        Book book = bookRepository.findBookByIsbn(request.addBookRequest().isbn()).orElse(null);
        if (book == null) {
            book = bookRepository.save(new Book(request.addBookRequest()));
            recommendService.embed(new EmbeddingRequest(request.addBookRequest().isbn(), request.addBookRequest().title(), request.addBookRequest().description()));
        }

        Club club;
        if (clubId == null) {
            club = null;
        }
        else {
            club = clubRepository.findClubById(clubId).orElseThrow(
                    ()-> new ClubException(CLUB_NOT_FOUND)
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
            if (!assignment.getAssignmentType().toString().equals(QUIZ_TYPE)) {
                throw new AssignmentException(NOT_MATCH_TYPE);
            }
        }

        Quiz saved = quizRepository.save(new Quiz(request, member, book, club, assignment));

        member.getQuizzes().add(saved);
        book.getQuizzes().add(saved);
        if (assignment != null) {
            assignment.getQuizzes().add(saved);
        }
        if (club != null) {
            club.getQuizzes().add(saved);
        }
    }


    public QuizResponse getQuiz(Long id) {
        Quiz quiz = quizRepository.findQuizById(id).orElseThrow(
                () -> new QuizException(QUIZ_NOT_FOUND)
        );
        return new QuizResponse(quiz);
    }
}
