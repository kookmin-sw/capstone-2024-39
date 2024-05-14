package com.project.capstone.book.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.book.controller.dto.AddBookRequest;
import com.project.capstone.club.domain.Club;
import com.project.capstone.content.domain.Content;
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
@Table(name = "book")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String isbn;
    private String title;
    private String description;
    private String author;
    private String publisher;
    @Column(name = "publish_date")
    private String publishDate;
    @Column(name = "image_url")
    private String imageUrl;

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

    public Book(AddBookRequest request) {
        this(null, request.isbn(), request.title(), request.description(), request.author(), request.publisher(), request.publishDate(),
                request.imageUrl(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>());
    }
}
