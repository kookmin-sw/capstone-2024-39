package com.project.capstone.comment.service;

import com.project.capstone.comment.controller.dto.CommentResponse;
import com.project.capstone.comment.controller.dto.CreateCommentRequest;
import com.project.capstone.comment.domain.Comment;
import com.project.capstone.comment.domain.CommentRepository;
import com.project.capstone.comment.exception.CommentException;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.post.domain.Post;
import com.project.capstone.post.domain.PostRepository;
import com.project.capstone.post.exception.PostException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

import static com.project.capstone.comment.exception.CommentExceptionType.COMMENT_NOT_FOUND;
import static com.project.capstone.member.exception.MemberExceptionType.MEMBER_NOT_FOUND;
import static com.project.capstone.post.exception.PostExceptionType.POST_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Slf4j
public class CommentService {

    private final CommentRepository commentRepository;
    private final MemberRepository memberRepository;
    private final PostRepository postRepository;

    public void createPost(String userId, Long postId, CreateCommentRequest request) {
        Member member = memberRepository.findMemberById(UUID.fromString(userId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );

        Post post = postRepository.findPostById(postId).orElseThrow(
                () -> new PostException(POST_NOT_FOUND)
        );

        Comment saved = commentRepository.save(Comment.builder()
                .body(request.body())
                .member(member)
                .post(post)
                .build());

        member.getComments().add(saved);
        post.getComments().add(saved);
    }


    public CommentResponse getComment(String userId, Long id) {
        if (memberRepository.findMemberById(UUID.fromString(userId)).isEmpty()) {
            throw new MemberException(MEMBER_NOT_FOUND);
        }
        Comment comment = commentRepository.findCommentById(id).orElseThrow(
                () -> new CommentException(COMMENT_NOT_FOUND)
        );
        return new CommentResponse(comment);
    }
}
