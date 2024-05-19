package com.project.capstone.recommend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.capstone.book.domain.Book;
import com.project.capstone.book.domain.BookRepository;
import com.project.capstone.content.domain.Content;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.quiz.domain.Quiz;
import com.project.capstone.recommend.controller.dto.EmbeddingRequest;
import com.project.capstone.recommend.controller.dto.RecommendRequest;
import com.project.capstone.recommend.controller.dto.RecommendResponse;
import com.project.capstone.recommend.exception.RecommendException;
import com.project.capstone.recommend.exception.RecommendExceptionType;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;
import static com.project.capstone.recommend.exception.RecommendExceptionType.COMMUNICATION_FAIL;
import static com.project.capstone.recommend.exception.RecommendExceptionType.INVALID_REQUEST;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecommendService {
    private final MemberRepository memberRepository;
    private final BookRepository bookRepository;

    public void embed(EmbeddingRequest request) {
        if (request.isbn() == null || request.title() == null || request.description() == null) {
            throw new RecommendException(INVALID_REQUEST);
        }
        WebClient webClient = WebClient.builder().build();
        String url = "http://localhost:8000/embed";

        try {
            String res = webClient.post()
                    .uri(url)
                    .bodyValue(request)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            log.info(res);
        } catch (Exception e) {
            throw new RecommendException(COMMUNICATION_FAIL);
        }

    }

    public RecommendResponse recommend(String userId) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        List<String> isbnList = new ArrayList<>();
        List<Content> contents = member.getContents();
        List<Quiz> quizzes = member.getQuizzes();
        // 사용자가 만든 컨텐츠가 하나라도 없는 경우
        if (contents.isEmpty() && quizzes.isEmpty()) {
            return randomRecommend();
        }
        for (Content content : contents) {
            isbnList.add(content.getBook().getIsbn());
        }
        for (Quiz quiz : quizzes) {
            isbnList.add(quiz.getBook().getIsbn());
        }
        RecommendRequest request = new RecommendRequest(isbnList);

        WebClient webClient = WebClient.builder().build();
        String url = "http://localhost:8000/recommend";

        try {
            List<String> res = webClient.post()
                    .uri(url)
                    .bodyValue(request)
                    .retrieve()
                    .bodyToMono(new ParameterizedTypeReference<List<String>>() {
                    })
                    .block();

            return new RecommendResponse(res);
        } catch (Exception e) {
            throw new RecommendException(COMMUNICATION_FAIL);
        }
    }

    public RecommendResponse randomRecommend() {
        List<String> booksByRandom = bookRepository.findBooksByRandom();
        return new RecommendResponse(booksByRandom);
    }
}
