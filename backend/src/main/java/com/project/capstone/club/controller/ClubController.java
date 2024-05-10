package com.project.capstone.club.controller;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.club.controller.dto.ClubCreateRequest;
import com.project.capstone.club.controller.dto.ClubResponse;
import com.project.capstone.club.controller.dto.SimpleClubResponse;
import com.project.capstone.club.service.ClubService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping("/club")
@Slf4j
public class ClubController {
    private final ClubService clubService;
    // 모임 불러오기
    @GetMapping("/search/{id}")
    public ResponseEntity<?> getClub(@PathVariable Long id) {
        ClubResponse clubResponse = clubService.getClub(id);
        return ResponseEntity.ok().body(clubResponse);
    }

    // 모임 주제별 검색
    @GetMapping("/search/topic")
    public ResponseEntity<List<ClubResponse>> searchByTopic(@RequestParam String topic) {
        List<ClubResponse> clubResponseList = clubService.searchByTopic(topic);
        return ResponseEntity.ok().body(clubResponseList);
    }
    // 모임 이름으로 검색
    @GetMapping("/search/name")
    public ResponseEntity<?> searchByName(@RequestParam String name) {
        List<ClubResponse> clubResponseList = clubService.searchByName(name);
        return ResponseEntity.ok().body(clubResponseList);
    }
    // 모임 생성하기
    @PostMapping("/create")
    public ResponseEntity<?> createClub(@RequestBody ClubCreateRequest request, @AuthenticationPrincipal PrincipalDetails details) {
        clubService.createClub(request, details.getUserId());
        return ResponseEntity.ok().body("모임 생성 완료");
    }
    // 모임 가입하기
    @GetMapping("/join")
    public ResponseEntity<?> join(@AuthenticationPrincipal PrincipalDetails details, @RequestParam Long clubId) {
        clubService.join(details.getUserId(), clubId);
        return ResponseEntity.ok().body("모임 가입 완료");
    }
    // 모임 탈퇴하기
    @GetMapping("/out")
    public ResponseEntity<?> out(@AuthenticationPrincipal PrincipalDetails details, @RequestParam Long clubId) {
        clubService.out(details.getUserId(), clubId);
        return ResponseEntity.ok().body("모임 탈퇴 완료");
    }
    // 모임장 위임하기
    @PutMapping("/delegate")
    public ResponseEntity<?> delegateManager(@AuthenticationPrincipal PrincipalDetails details,
                                             @RequestParam UUID memberId, @RequestParam Long clubId) {
        clubService.delegateManager(details.getUserId(), memberId, clubId);
        return ResponseEntity.ok().body("위임 완료");
    }
    // 멤버 추방하기
    @GetMapping("/expel")
    public ResponseEntity<?> expelMember(@AuthenticationPrincipal PrincipalDetails details,
                                         @RequestParam UUID memberId, @RequestParam Long clubId) {
        clubService.expelMember(details.getUserId(), memberId, clubId);
        return ResponseEntity.ok().body("추방 완료");
    }

    // 대표책 선정하기
    @PostMapping("/book")
    public ResponseEntity<?> setBook(@AuthenticationPrincipal PrincipalDetails details,
                                     @RequestBody AddBookRequest request, @RequestParam Long clubId) {
        clubService.setBook(details.getUserId(), request, clubId);
        return ResponseEntity.ok().body("선정 완료");
    }

    // 대표책으로 모임 조회
    @GetMapping("/search/book")
    public ResponseEntity<List<SimpleClubResponse>> getClubByBookName(@RequestParam String title) {
        List<SimpleClubResponse> clubResponseList = clubService.getClubByBookTitle(title);
        return ResponseEntity.ok().body(clubResponseList);
    }
}
