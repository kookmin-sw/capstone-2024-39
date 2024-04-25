package com.project.capstone.quiz.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.project.capstone.book.domain.Book;
import com.project.capstone.club.domain.Club;
import com.project.capstone.member.domain.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private QuizType type;
    private String description;
    private String answer;
    private String example1;
    private String example2;
    private String example3;
    private String example4;

    @JsonBackReference
    @ManyToOne
    private Member member;

    @JsonBackReference
    @ManyToOne
    private Book book;

    @JsonBackReference
    @ManyToOne
    private Club club;

}
