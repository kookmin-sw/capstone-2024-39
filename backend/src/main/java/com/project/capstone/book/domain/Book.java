package com.project.capstone.book.domain;

import com.project.capstone.club.domain.Club;
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
    private String title;
    @Column(name = "category_1d")
    private String category1d;
    @Column(name = "category_2d")
    private String category2d;
    @Column(name = "category_3d")
    private String category3d;
    private String author;
    private String publisher;
    private String publish_date;

    @OneToMany(mappedBy = "book")
    private List<Club> clubs = new ArrayList<>();
}
