package com.project.capstone.auth.jwt;


import com.project.capstone.auth.exception.AuthException;
import com.project.capstone.member.exception.MemberException;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

import static com.project.capstone.auth.exception.AuthExceptionType.*;
import static com.project.capstone.member.exception.MemberExceptionType.*;

@RequiredArgsConstructor
@Component
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtProvider jwtProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String token = jwtProvider.resolveToken(request);
        try {
            String id = jwtProvider.validateTokenAndGetId(token);
            Authentication authentication = jwtProvider.createAuthentication(id);
            log.info(authentication.getName());
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (SecurityException e) {
            request.setAttribute("exception", new AuthException(SIGNATURE_NOT_FOUND));
        } catch (SignatureException e) {
            request.setAttribute("exception", new AuthException(SIGNATURE_INVALID));
        } catch (MalformedJwtException e) {
            request.setAttribute("exception", new AuthException(MALFORMED_TOKEN));
        } catch (ExpiredJwtException e) {
            request.setAttribute("exception", new AuthException(EXPIRED_TOKEN));
        } catch (UnsupportedJwtException e) {
            request.setAttribute("exception", new AuthException(UNSUPPORTED_TOKEN));
        } catch (IllegalArgumentException e) {
            request.setAttribute("exception", new AuthException(INVALID_TOKEN));
        } catch (UsernameNotFoundException e) {
            request.setAttribute("exception", new MemberException(MEMBER_NOT_FOUND));
        } catch (Exception e) {
            request.setAttribute("exception", new Exception());
        }

        filterChain.doFilter(request, response);
    }
}
