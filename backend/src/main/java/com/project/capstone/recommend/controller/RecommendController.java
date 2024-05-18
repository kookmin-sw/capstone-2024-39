package com.project.capstone.recommend.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.recommend.controller.dto.RecommendResponse;
import com.project.capstone.recommend.service.RecommendService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequiredArgsConstructor
public class RecommendController {
    private final RecommendService recommendService;

    // 로그인 유저 전용
    @GetMapping("/rec/member")
    public ResponseEntity<RecommendResponse> recommend(@AuthenticationPrincipal PrincipalDetails details) {
        RecommendResponse recommend = recommendService.recommend(details.getUserId());
        return ResponseEntity.ok().body(recommend);
    }

    @GetMapping("/rec/anonymous")
    public ResponseEntity<RecommendResponse> randomRecommend() {
        RecommendResponse recommend = recommendService.randomRecommend();
        return ResponseEntity.ok().body(recommend);
    }
}
