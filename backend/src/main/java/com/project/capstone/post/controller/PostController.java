package com.project.capstone.post.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.post.controller.dto.PostCreateRequest;
import com.project.capstone.post.controller.dto.PostResponse;
import com.project.capstone.post.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/post")
public class PostController {

    private final PostService postService;

    // 게시글 작성하기
    @PostMapping("/create")
    public ResponseEntity<?> createPost(@AuthenticationPrincipal PrincipalDetails details,
                                        @RequestBody PostCreateRequest request, @RequestParam Long clubId) {
        postService.createPost(details.getUserId(), request, clubId);
        return ResponseEntity.ok().body("게시글 생성");
    }

    // 게시글 조회
    @GetMapping("/{postId}")
    public ResponseEntity<PostResponse> getPost(@AuthenticationPrincipal PrincipalDetails details,
                                                @PathVariable Long postId, @RequestParam Long clubId) {
        PostResponse postResponse = postService.getPost(details.getUserId(), postId, clubId);
        return ResponseEntity.ok().body(postResponse);
    }


}
