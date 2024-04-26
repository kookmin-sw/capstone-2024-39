package com.project.capstone.memberclub.domain;

import com.project.capstone.club.domain.Club;
import com.project.capstone.member.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;


public interface MemberClubRepository extends JpaRepository<MemberClub, Long> {
    void deleteMemberClubByClub_IdAndMember_Id(Long clubId, UUID memberId);
    Optional<MemberClub> findMemberClubByMember_IdAndClub_Id(UUID memberId, Long clubId);
    List<MemberClub> findMemberClubsByMember_Id(UUID memberId);
    Optional<MemberClub> findMemberClubByMemberAndClub(Member member, Club club);

}
