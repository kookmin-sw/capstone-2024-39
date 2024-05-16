package com.project.capstone.recommend.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.recommend.controller.dto.RecommendResponse;
import com.project.capstone.recommend.service.RecommendService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/rec")
public class RecommendController {
    private final RecommendService recommendService;

    @GetMapping("/")
    public ResponseEntity<RecommendResponse> recommend(@AuthenticationPrincipal PrincipalDetails details) {
        RecommendResponse recommend = recommendService.recommend(details.getUserId());
        return ResponseEntity.ok().body(recommend);
    }
}
