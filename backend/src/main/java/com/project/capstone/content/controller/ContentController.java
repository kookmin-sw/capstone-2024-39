package com.project.capstone.content.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.content.controller.dto.ContentCreateRequest;
import com.project.capstone.content.controller.dto.ContentResponse;
import com.project.capstone.content.service.ContentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/content")
public class ContentController {

    private final ContentService contentService;

    // 컨텐츠 생성
    @PostMapping("/create")
    public ResponseEntity<?> createContent(@AuthenticationPrincipal PrincipalDetails details,
                                           @RequestBody ContentCreateRequest request,
                                           @RequestParam(required = false) Long clubId, @RequestParam(required = false) Long asId) {
        contentService.createContent(details.getUserId(), request, clubId, asId);
        return ResponseEntity.ok().body("컨텐츠 생성 완료");
    }

    // 단일 컨텐츠 조회
    @GetMapping("/{id}")
    public ResponseEntity<ContentResponse> getContent(@PathVariable Long id) {
        ContentResponse contentResponse = contentService.getContent(id);
        return ResponseEntity.ok().body(contentResponse);
    }

    // 컨텐츠 종류별 조회
    @GetMapping("/get")
    public ResponseEntity<List<ContentResponse>> getContents(@RequestParam String type, @RequestParam Long clubId) {
        List<ContentResponse> contentResponseList = contentService.getContents(type, clubId);
        return ResponseEntity.ok().body(contentResponseList);
    }
}
