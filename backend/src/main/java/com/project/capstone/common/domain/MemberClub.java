package com.project.capstone.common.domain;

import com.project.capstone.club.domain.Club;
import com.project.capstone.member.domain.Member;
import jakarta.persistence.*;

@Entity
public class MemberClub {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Member member;

    @ManyToOne
    private Club club;
}
