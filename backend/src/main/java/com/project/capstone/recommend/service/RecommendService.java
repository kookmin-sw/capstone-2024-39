package com.project.capstone.recommend.service;

import com.project.capstone.recommend.controller.dto.EmbeddingRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Service
@Slf4j
public class RecommendService {

    public void embed(EmbeddingRequest embeddingRequest) {
        WebClient webClient = WebClient.builder().build();
        String url = "http://localhost:8000/embed";

        String res = webClient.post()
                .uri(url)
                .bodyValue(embeddingRequest)
                .retrieve()
                .bodyToMono(String.class)
                .block();

        log.info(res);
    }
}
