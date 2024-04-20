package com.project.capstone.club.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.book.domain.Book;
import com.project.capstone.memberclub.domain.MemberClub;
import com.project.capstone.content.domain.Content;
import com.project.capstone.post.domain.Post;
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
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder
public class Club {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "manager_id", columnDefinition = "BINARY(16)")
    private UUID managerId;
    private String topic;
    private String name;
    @Column(name = "created_at")
    @CreatedDate
    private LocalDateTime createdAt;
    private int maximum;
    @Enumerated(EnumType.STRING)
    @Column(name = "public_status")
    private PublicStatus publicStatus;
    private Integer password;

    @JsonManagedReference
    @OneToMany(mappedBy = "club")
    private List<Post> posts = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "club")
    private List<MemberClub> members = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "club")
    private List<Content> contents = new ArrayList<>();

    @ManyToOne
    private Book book;

}
