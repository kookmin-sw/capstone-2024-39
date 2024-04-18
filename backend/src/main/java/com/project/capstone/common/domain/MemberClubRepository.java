package com.project.capstone.common.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;


public interface MemberClubRepository extends JpaRepository<MemberClub, Long> {
    void deleteMemberClubByClub_IdAndMember_Id(Long clubId, UUID memberId);
    Optional<MemberClub> findMemberClubByMember_IdAndClub_Id(UUID memberId, Long clubId);
}
