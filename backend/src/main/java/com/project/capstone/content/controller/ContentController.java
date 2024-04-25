package com.project.capstone.content.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.content.controller.dto.ContentCreateRequest;
import com.project.capstone.content.service.ContentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/content")
public class ContentController {

    private final ContentService contentService;

    @PostMapping("/create")
    public ResponseEntity<?> createContent(@AuthenticationPrincipal PrincipalDetails details,
                                           @RequestBody ContentCreateRequest request,
                                           @RequestParam Long bookId, @RequestParam(required = false) Long clubId) {
        contentService.createContent(details.getUserId(), request, bookId, clubId);
        return ResponseEntity.ok().body("컨텐츠 생성 완료");
    }
}
