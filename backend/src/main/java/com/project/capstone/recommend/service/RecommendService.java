package com.project.capstone.recommend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.capstone.content.domain.Content;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.recommend.controller.dto.EmbeddingRequest;
import com.project.capstone.recommend.controller.dto.RecommendRequest;
import com.project.capstone.recommend.controller.dto.RecommendResponse;
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

@Service
@RequiredArgsConstructor
@Slf4j
public class RecommendService {
    private final MemberRepository memberRepository;

    public void embed(EmbeddingRequest request) {
        WebClient webClient = WebClient.builder().build();
        String url = "http://localhost:8000/embed";

        String res = webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .bodyToMono(String.class)
                .block();

        log.info(res);
    }

    public RecommendResponse recommend(String userId) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        List<Content> contents = member.getContents();
        List<String> isbnList = new ArrayList<>();
        for (Content content : contents) {
            isbnList.add(content.getBook().getIsbn());
        }
        RecommendRequest request = new RecommendRequest(isbnList);

        WebClient webClient = WebClient.builder().build();
        String url = "http://localhost:8000/recommend";

        List<String> res = webClient.post()
                .uri(url)
                .bodyValue(request)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<List<String>>() {
                })
                .block();

        return new RecommendResponse(res);
    }
}
