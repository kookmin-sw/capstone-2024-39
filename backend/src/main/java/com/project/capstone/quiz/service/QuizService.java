package com.project.capstone.quiz.service;

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
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

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

    public void createQuiz(String userId, CreateQuizRequest request, Long bookId, Long clubId) {
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
                    ()-> new ClubException(CLUB_NOT_FOUND)
            );
        }

        Quiz saved = quizRepository.save(
                Quiz.builder()
                        .type(request.type())
                        .description(request.description())
                        .answer(request.answer())
                        .example1(request.example1())
                        .example2(request.example2())
                        .example3(request.example3())
                        .example4(request.example4())
                        .member(member)
                        .book(book)
                        .club(club)
                        .build()
        );

        member.getQuizzes().add(saved);
        book.getQuizzes().add(saved);
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
