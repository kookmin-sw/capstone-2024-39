package com.project.capstone.content.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.project.capstone.assignment.domain.Assignment;
import com.project.capstone.book.domain.Book;
import com.project.capstone.club.domain.Club;
import com.project.capstone.content.controller.dto.ContentCreateRequest;
import com.project.capstone.member.domain.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "content")
public class Content {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "content_type")
    private ContentType type;
    private String title;
    private String body;
    private int likes;

    @Column(name = "start_date")
    private String startDate;

    @Column(name = "end_date")
    private String endDate;

    @JsonBackReference
    @ManyToOne
    private Member member;

    @JsonBackReference
    @ManyToOne
    private Book book;

    @JsonBackReference
    @ManyToOne
    private Club club;

    @JsonBackReference
    @ManyToOne
    private Assignment assignment;

    public Content(ContentCreateRequest request, Member member, Book book, Club club, Assignment assignment) {
        this(null, request.contentType(), request.title(), request.body(), 0, request.startDate(), request.endDate(),
                member, book, club, assignment);
    }
}
