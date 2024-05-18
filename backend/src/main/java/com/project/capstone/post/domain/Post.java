package com.project.capstone.post.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.club.domain.Club;
import com.project.capstone.comment.domain.Comment;
import com.project.capstone.member.domain.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "post")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String writer;
    private String title;
    private String body;
    @CreatedDate
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @Column(name = "is_sticky")
    private boolean isSticky;

    @JsonManagedReference
    @OneToMany(mappedBy = "post")
    private List<Comment> comments = new ArrayList<>();

    @JsonBackReference
    @ManyToOne
    private Member member;

    @JsonBackReference
    @ManyToOne
    private Club club;
}
