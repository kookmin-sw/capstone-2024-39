package com.project.capstone.post.service;

import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.club.exception.ClubException;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.memberclub.domain.MemberClubRepository;
import com.project.capstone.memberclub.exception.MemberClubException;
import com.project.capstone.memberclub.exception.MemberClubExceptionType;
import com.project.capstone.post.controller.dto.PostCreateRequest;
import com.project.capstone.post.controller.dto.PostResponse;
import com.project.capstone.post.domain.Post;
import com.project.capstone.post.domain.PostRepository;
import com.project.capstone.post.exception.PostException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

import static com.project.capstone.club.exception.ClubExceptionType.*;
import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;
import static com.project.capstone.memberclub.exception.MemberClubExceptionType.*;
import static com.project.capstone.post.exception.PostExceptionType.POST_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class PostService {

    private final PostRepository postRepository;
    private final MemberRepository memberRepository;
    private final ClubRepository clubRepository;
    private final MemberClubRepository memberClubRepository;

    public void createPost(String memberId, PostCreateRequest request, Long clubId) {
        Member member = memberRepository.findMemberById(UUID.fromString(memberId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );

        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(UUID.fromString(memberId), clubId).isEmpty()) {
            throw new MemberClubException(MEMBERCLUB_NOT_FOUND);
        }

        Post saved = postRepository.save(Post.builder()
                .title(request.title())
                .body(request.body())
                .isSticky(request.isSticky())
                .member(member)
                .club(club)
                .build());

        member.getPosts().add(saved);
        club.getPosts().add(saved);
    }

    public PostResponse getPost(String memberId, Long id, Long clubId) {
        Post post = postRepository.findPostById(id).orElseThrow(
                () -> new PostException(POST_NOT_FOUND)
        );
        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(UUID.fromString(memberId), clubId).isEmpty()) {
            throw new MemberClubException(MEMBERCLUB_NOT_FOUND);
        }
        return new PostResponse(post);
    }
}
