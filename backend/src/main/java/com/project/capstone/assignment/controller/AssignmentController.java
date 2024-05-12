package com.project.capstone.assignment.controller;

import com.project.capstone.assignment.controller.dto.CreateAssignmentRequest;
import com.project.capstone.assignment.service.AssignmentService;
import com.project.capstone.auth.domain.PrincipalDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/assign")
@RequiredArgsConstructor
public class AssignmentController {

    private final AssignmentService assignmentService;

    // 과제 생성
    @PostMapping("/create")
    public ResponseEntity<?> createAssignment(@AuthenticationPrincipal PrincipalDetails details,
                                              @RequestBody CreateAssignmentRequest request, @RequestParam Long clubId) {
        assignmentService.createAssignment(details.getUserId(), request, clubId);
        return ResponseEntity.ok().body("과제 생성 완료");
    }

    // 모임의 과제 조회
}
