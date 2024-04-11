package com.project.capstone.auth.controller;

import com.project.capstone.auth.controller.dto.LoginRequest;
import com.project.capstone.auth.controller.dto.SignupRequest;
import com.project.capstone.auth.controller.dto.TokenResponse;
import com.project.capstone.auth.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/auth")
@RequiredArgsConstructor
@RestController
public class AuthController {

    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupRequest request) {
        authService.signup(request);
        TokenResponse tokenResponse = authService.login(request.email());
        return ResponseEntity.ok().body(tokenResponse);
    }

    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(@RequestBody LoginRequest request) {
        TokenResponse tokenResponse = authService.login(request.email());
        return ResponseEntity.ok().body(tokenResponse);
    }
}
