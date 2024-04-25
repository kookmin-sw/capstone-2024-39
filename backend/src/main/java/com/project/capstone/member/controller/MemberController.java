package com.project.capstone.member.controller;

import com.project.capstone.member.controller.dto.MemberResponse;
import com.project.capstone.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping("/member")
public class MemberController {

    private final MemberService memberService;

    @GetMapping("/{id}")
    public ResponseEntity<MemberResponse> getMember(@PathVariable UUID id) {
        MemberResponse memberResponse = memberService.getMember(id);
        return ResponseEntity.ok().body(memberResponse);
    }
}
