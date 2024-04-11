package com.project.capstone.auth.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Slf4j
@Component
public class JwtProvider {

    @Value("${jwt.secret}")
    private String secret;
    private Key key;
    private static final int EXPIRED_DURATION = 24;

    @PostConstruct
    private void init() {
        key = Keys.hmacShaKeyFor(secret.getBytes());
    }

    public String generate(String email) {
        Claims claims = Jwts.claims();
        claims.put("email", email);
        return generateToken(claims);
    }

    private String generateToken(Claims claims) {
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(issueAt())
                .setExpiration(expireAt())
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    private Date expireAt() {
        LocalDateTime now = LocalDateTime.now();
        log.info(Date.from(now.plusHours(EXPIRED_DURATION).atZone(ZoneId.systemDefault()).toInstant()).toString());
        return Date.from(now.plusHours(EXPIRED_DURATION).atZone(ZoneId.systemDefault()).toInstant());
    }

    private Date issueAt() {
        LocalDateTime now = LocalDateTime.now();
        log.info(Date.from(now.atZone(ZoneId.systemDefault()).toInstant()).toString());
        return Date.from(now.atZone(ZoneId.systemDefault()).toInstant());
    }
}
