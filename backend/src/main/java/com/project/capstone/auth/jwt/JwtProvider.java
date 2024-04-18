package com.project.capstone.auth.jwt;

import com.project.capstone.auth.service.PrincipalDetailService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.security.Key;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.UUID;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtProvider {

    @Value("${jwt.secret}")
    private String secret;
    private Key key;
    private static final int EXPIRED_DURATION = 24;
    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String GRANT_TYPE = "Bearer ";
    private final PrincipalDetailService principalDetailService;

    @PostConstruct
    private void init() {
        key = Keys.hmacShaKeyFor(secret.getBytes());
    }

    public String generate(String id) {
        Claims claims = Jwts.claims();
        claims.put("id", id);
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

    public String resolveToken(HttpServletRequest request) {
        String bearToken = request.getHeader(AUTHORIZATION_HEADER);
        if (StringUtils.hasText(bearToken) && bearToken.startsWith(GRANT_TYPE)) {
            return bearToken.substring(7);
        }
        return null;
    }

    public String validateTokenAndGetId(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .get("id", String.class);
    }

    public Authentication createAuthentication(String id) {
        UserDetails userDetails = principalDetailService.loadUserByUsername(id);
        return new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
    }
}
