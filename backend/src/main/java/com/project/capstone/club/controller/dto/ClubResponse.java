package com.project.capstone.club.controller.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.project.capstone.book.controller.dto.BookResponse;
import com.project.capstone.book.domain.Book;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.PublicStatus;
import com.project.capstone.post.controller.dto.PostResponse;
import com.project.capstone.post.domain.Post;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public record ClubResponse (
        Long id,
        BookResponse book,
        String topic,
        String name,
        LocalDateTime createdAt,
        int maximum,
        PublicStatus publicstatus,
        List<PostResponse> posts

) {
    public ClubResponse(Club club) {
        this(club.getId(), club.getBook() == null ? null : createBookResponse(club.getBook()), club.getTopic(), club.getName(), club.getCreatedAt(), club.getMaximum(),
                club.getPublicStatus(), createPostResponseList(club.getPosts()));
    }

    private static List<PostResponse> createPostResponseList(List<Post> postList) {
        List<PostResponse> postResponseList = new ArrayList<>();
        for (Post post : postList) {
            postResponseList.add(new PostResponse(post));
        }
        return postResponseList;
    }

    private static BookResponse createBookResponse(Book book) {
        return new BookResponse(book);
    }
}