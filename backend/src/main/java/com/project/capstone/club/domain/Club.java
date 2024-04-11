package com.project.capstone.club.domain;

import com.project.capstone.book.domain.Book;
import com.project.capstone.common.domain.MemberClub;
import com.project.capstone.content.domain.Content;
import com.project.capstone.member.domain.Member;
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
    private String topic;
    private String name;
    @Column(name = "created_at")
    @CreatedDate
    private LocalDateTime createdAt;
    private int maximum;
    @Column(name = "is_public")
    private boolean isPublic;
    private Integer password;

    @OneToMany(mappedBy = "club")
    private List<Post> posts = new ArrayList<>();

    @OneToMany(mappedBy = "club")
    private List<MemberClub> members = new ArrayList<>();

    @OneToMany(mappedBy = "club")
    private List<Content> contents = new ArrayList<>();

    @ManyToOne
    private Book book;
}
