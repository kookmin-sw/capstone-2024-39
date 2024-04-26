package com.project.capstone.comment.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.comment.controller.dto.CommentResponse;
import com.project.capstone.comment.controller.dto.CreateCommentRequest;
import com.project.capstone.comment.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/comment")
public class CommentController {

    private final CommentService commentService;

    @PostMapping("create")
    public ResponseEntity<?> createComment(@AuthenticationPrincipal PrincipalDetails details,
                                           @RequestParam Long postId, @RequestBody CreateCommentRequest request) {
        commentService.createPost(details.getUserId(), postId, request);
        return ResponseEntity.ok().body("댓글 생성 완료");
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getComment(@AuthenticationPrincipal PrincipalDetails details,
                                        @PathVariable Long id) {
        CommentResponse commentResponse = commentService.getComment(details.getUserId(), id);
        return ResponseEntity.ok().body(commentResponse);
    }

}
