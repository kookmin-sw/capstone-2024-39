package com.project.capstone.club.controller.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.project.capstone.book.controller.dto.BookResponse;
import com.project.capstone.book.domain.Book;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.PublicStatus;
import com.project.capstone.member.controller.dto.SimpleMemberResponse;
import com.project.capstone.memberclub.domain.MemberClub;
import com.project.capstone.post.controller.dto.PostResponse;
import com.project.capstone.post.domain.Post;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public record ClubResponse (
        Long id,
        BookResponse book,
        UUID managerId,
        String topic,
        String name,
        LocalDateTime createdAt,
        int maximum,
        int memberCnt,
        PublicStatus publicstatus,
        List<PostResponse> posts,
        List<SimpleMemberResponse> memberList

) {
    public ClubResponse(Club club) {
        this(club.getId(), club.getBook() == null ? null : createBookResponse(club.getBook()), club.getManagerId(), club.getTopic(), club.getName(), club.getCreatedAt(), club.getMaximum(),
                club.getMembers().size(), club.getPublicStatus(), createPostResponseList(club.getPosts()), createSimpleMemberResponse(club.getMembers()));
    }

    private static List<PostResponse> createPostResponseList(List<Post> postList) {
        List<PostResponse> postResponseList = new ArrayList<>();
        for (Post post : postList) {
            postResponseList.add(new PostResponse(post));
        }
        return postResponseList;
    }

    private static List<SimpleMemberResponse> createSimpleMemberResponse(List<MemberClub> memberClubList) {
        List<SimpleMemberResponse> simpleMemberResponseList = new ArrayList<>();
        for (MemberClub memberClub : memberClubList) {
            simpleMemberResponseList.add(new SimpleMemberResponse(memberClub));
        }
        return simpleMemberResponseList;
    }

    private static BookResponse createBookResponse(Book book) {
        return new BookResponse(book);
    }
}