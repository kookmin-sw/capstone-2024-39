package com.project.capstone.member.controller.dto;

import com.project.capstone.club.domain.Club;
import com.project.capstone.comment.controller.dto.CommentResponse;
import com.project.capstone.comment.domain.Comment;
import com.project.capstone.content.controller.dto.ContentResponse;
import com.project.capstone.content.domain.Content;
import com.project.capstone.member.domain.Gender;
import com.project.capstone.member.domain.Member;
import com.project.capstone.memberclub.domain.MemberClub;
import com.project.capstone.post.controller.dto.PostResponse;
import com.project.capstone.post.controller.dto.SimplePostResponse;
import com.project.capstone.post.domain.Post;
import com.project.capstone.quiz.controller.dto.QuizResponse;
import com.project.capstone.quiz.domain.Quiz;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public record MemberResponse (
    UUID id,
    String email,
    String name,
    int age,
    Gender gender,
    LocalDateTime createdAt,
    List<MemberClub> clubsList,
    List<SimplePostResponse> postList,
    List<CommentResponse> commentList,
    List<ContentResponse> contentList,
    List<QuizResponse> quizList
) {
    public MemberResponse(Member member) {
        this(member.getId(), member.getEmail(), member.getName(), member.getAge(), member.getGender(), member.getCreatedAt(),
                member.getClubs(), createSimplePostResponseList(member.getPosts()), createCommentResponseList(member.getComments()),
                createContentResponseList(member.getContents()), createQuizResponseList(member.getQuizzes()));
    }

    private static List<SimplePostResponse> createSimplePostResponseList(List<Post> postList) {
        List<SimplePostResponse> simplePostResponses = new ArrayList<>();
        for (Post post: postList) {
            simplePostResponses.add(new SimplePostResponse(post));
        }
        return simplePostResponses;
    }

    private static List<CommentResponse> createCommentResponseList(List<Comment> commentList) {
        List<CommentResponse> commentResponseList = new ArrayList<>();
        for (Comment comment: commentList) {
            commentResponseList.add(new CommentResponse(comment));
        }
        return commentResponseList;
    }

    private static List<ContentResponse> createContentResponseList(List<Content> contentList) {
        List<ContentResponse> contentResponseList = new ArrayList<>();
        for (Content content : contentList) {
            contentResponseList.add(new ContentResponse(content));
        }
        return contentResponseList;
    }
    private static List<QuizResponse> createQuizResponseList(List<Quiz> quizList) {
        List<QuizResponse> quizResponseList = new ArrayList<>();
        for (Quiz quiz : quizList) {
            quizResponseList.add(new QuizResponse(quiz));
        }
        return quizResponseList;
    }



}
