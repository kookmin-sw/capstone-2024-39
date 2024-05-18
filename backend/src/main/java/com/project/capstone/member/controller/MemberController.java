package com.project.capstone.member.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.member.controller.dto.MemberResponse;
import com.project.capstone.member.controller.dto.MyBookResponse;
import com.project.capstone.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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

    // 나만의 서재 조회
    @GetMapping("/my-book")
    public ResponseEntity<List<MyBookResponse>> getMyBook(@AuthenticationPrincipal PrincipalDetails details) {
        List<MyBookResponse> myBooks = memberService.getMyBooks(details.getUserId());
        return ResponseEntity.ok().body(myBooks);
    }

    // 나만의 서재 추가
    @PostMapping("/my-book/add")
    public ResponseEntity<?> addMyBook(@AuthenticationPrincipal PrincipalDetails details,
                                       @RequestBody AddBookRequest request, @RequestParam String groupName) {
        memberService.addMyBook(details.getUserId(), request, groupName);
        return ResponseEntity.ok().body("추가 완료");
    }

    @PostMapping("/my-book/adds")
    public ResponseEntity<?> addMyBooks(@AuthenticationPrincipal PrincipalDetails details,
                                        @RequestBody List<AddBookRequest> requests, @RequestParam String groupName) {
        memberService.addMyBooks(details.getUserId(), requests, groupName);
        return ResponseEntity.ok().body("추가 완료");
    }

    @DeleteMapping("/my-book/rm/group")
    public ResponseEntity<?> removeMyBookGroup(@AuthenticationPrincipal PrincipalDetails details, @RequestParam String groupName) {
        memberService.removeMyBookGroup(details.getUserId(), groupName);
        return ResponseEntity.ok().body("나만의 서재 삭제 완료");
    }

    @DeleteMapping("/my-book/rm/book")
    public ResponseEntity<?> removeMyBook(@AuthenticationPrincipal PrincipalDetails details,
                                          @RequestParam String groupName, @RequestParam String isbn) {
        memberService.removeMyBook(details.getUserId(), groupName, isbn);
        return ResponseEntity.ok().body("나만의 서재의 책 삭제 완료");
    }
}
