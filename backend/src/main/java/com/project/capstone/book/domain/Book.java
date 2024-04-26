package com.project.capstone.book.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.club.domain.Club;
import com.project.capstone.content.domain.Content;
import com.project.capstone.member.controller.dto.AddMyBookRequest;
import com.project.capstone.mybook.domain.MyBook;
import com.project.capstone.quiz.domain.Quiz;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String isbn;
    private String title;
    @Column(name = "category_1d")
    private String category1d;
    @Column(name = "category_2d")
    private String category2d;
    @Column(name = "category_3d")
    private String category3d;
    private String author;
    private String publisher;
    @Column(name = "publish_date")
    private String publishDate;

    @JsonManagedReference
    @OneToMany(mappedBy = "book")
    private List<Club> clubs = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "book")
    private List<Content> contents = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "book")
    private List<Quiz> quizzes = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "book")
    private List<MyBook> membersAddThisBook = new ArrayList<>();

    public Book(AddMyBookRequest request) {
        this(null, request.isbn(), request.title(), request.category1d(), request.category2d(), request.category3d(),
                request.author(), request.publisher(), request.publishDate(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>());
    }
}
