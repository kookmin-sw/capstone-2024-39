package com.project.capstone.memberclub.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.project.capstone.club.domain.Club;
import com.project.capstone.member.domain.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class MemberClub {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "club_id")
    private Club club;

}
