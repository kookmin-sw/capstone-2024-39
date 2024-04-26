package com.project.capstone.member.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.auth.controller.dto.SignupRequest;
import com.project.capstone.club.domain.Club;
import com.project.capstone.comment.domain.Comment;
import com.project.capstone.memberclub.domain.MemberClub;
import com.project.capstone.content.domain.Content;
import com.project.capstone.mybook.domain.MyBook;
import com.project.capstone.post.domain.Post;
import com.project.capstone.quiz.domain.Quiz;
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
import java.util.UUID;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(columnDefinition = "BINARY(16)")
    private UUID id;
    private String email;
    private String name;
    private int age;
    @Enumerated(EnumType.STRING)
    private Gender gender;
    @CreatedDate
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @JsonManagedReference
    @OneToMany(mappedBy = "member")
    private List<MemberClub> clubs = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "member")
    private List<Post> posts = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "member")
    private List<Comment> comments = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "member")
    private List<Content> contents = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "member")
    private List<Quiz> quizzes = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "member")
    private List<MyBook> myBooks = new ArrayList<>();

    public Member(SignupRequest request) {
        this(null, request.email(), request.name(), request.age(), request.gender(), null,
                new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>());
    }

}
