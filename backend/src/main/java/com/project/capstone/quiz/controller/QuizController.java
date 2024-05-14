package com.project.capstone.quiz.controller;


import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.quiz.controller.dto.CreateQuizRequest;
import com.project.capstone.quiz.controller.dto.QuizResponse;
import com.project.capstone.quiz.service.QuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/quiz")
public class QuizController {
    private final QuizService quizService;

    // 퀴즈 생성
    @PostMapping("/create")
    public ResponseEntity<?> createQuiz(@AuthenticationPrincipal PrincipalDetails details,
                                        @RequestBody CreateQuizRequest request,
                                        @RequestParam(required = false) Long clubId, @RequestParam(required = false) Long asId) {
        quizService.createQuiz(details.getUserId(), request, clubId, asId);
        return ResponseEntity.ok().body("퀴즈 생성 완료");
    }

    // 단건 조회
    @GetMapping("/search/{id}")
    public ResponseEntity<QuizResponse> getQuiz(@PathVariable Long id) {
        QuizResponse quizResponse = quizService.getQuiz(id);
        return ResponseEntity.ok().body(quizResponse);
    }
}
