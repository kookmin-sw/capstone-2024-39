package com.project.capstone.mybook.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.project.capstone.book.domain.Book;
import com.project.capstone.member.domain.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class MyBook {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference
    @ManyToOne
    private Member member;

    @JsonBackReference
    @ManyToOne
    private Book book;

}
