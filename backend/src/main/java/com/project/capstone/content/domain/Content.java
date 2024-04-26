package com.project.capstone.content.domain;

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
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Content {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String type;
    @Column(name = "quiz_type")
    private String quizType;
    @Column(name = "quiz_answer")
    private String quizAnswer;
    private String title;
    private String body;
    private String likes;

    @ManyToOne
    private Member member;

    @ManyToOne
    private Book book;

    @ManyToOne
    private Club club;
}
