package com.project.capstone.club.service;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.club.controller.dto.ClubCreateRequest;
import com.project.capstone.club.controller.dto.ClubResponse;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.club.exception.ClubException;
import com.project.capstone.memberclub.domain.MemberClub;
import com.project.capstone.memberclub.domain.MemberClubRepository;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import com.project.capstone.member.exception.MemberException;
import com.project.capstone.memberclub.exception.MemberClubException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.project.capstone.club.exception.ClubExceptionType.*;
import static com.project.capstone.member.exception.MemberExceptionType.*;
import static com.project.capstone.memberclub.exception.MemberClubExceptionType.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class ClubService {
    private final ClubRepository clubRepository;
    private final MemberClubRepository memberClubRepository;
    private final MemberRepository memberRepository;

    public List<ClubResponse> searchByTopic(String topic) {
        List<ClubResponse> clubResponseList = new ArrayList<>();
        log.info(topic);
        List<Club> clubList = clubRepository.findClubsByTopic(topic);
        for (Club club : clubList) {
            clubResponseList.add(new ClubResponse(club));
        }
        return clubResponseList;
    }
    public List<ClubResponse> searchByName(String name) {
        List<ClubResponse> clubResponseList = new ArrayList<>();
        List<Club> clubList = clubRepository.findClubsByNameContaining(name);
        for (Club club : clubList) {
            clubResponseList.add(new ClubResponse(club));
        }
        return clubResponseList;
    }

    @Transactional
    public void createClub(ClubCreateRequest request, String memberId) {
        Club savedClub = clubRepository.save(new Club(request, UUID.fromString(memberId)));
        join(memberId, savedClub.getId());
    }

    public void join(String memberId, Long clubId) {
        Member member = memberRepository.findMemberById(UUID.fromString(memberId)).orElseThrow(
                () -> new MemberException(MEMBER_NOT_FOUND)
        );
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );
        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(UUID.fromString(memberId), clubId).isPresent()) {
            throw new MemberClubException(ALREADY_JOIN);
        }
        MemberClub saved = memberClubRepository.save(new MemberClub(null, member, club));
        member.getClubs().add(saved);
        club.getMembers().add(saved);
    }

    @Transactional
    public void out(String userId, Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );
        if (club.getManagerId().toString().equals(userId)) {
            throw new ClubException(EXIT_WITHOUT_DELEGATION);
        }
        memberClubRepository.deleteMemberClubByClub_IdAndMember_Id(clubId, UUID.fromString(userId));
    }

    @Transactional
    public void delegateManager(PrincipalDetails details, UUID memberId, Long clubId) {
        checkIsManagerAndTargetIsClubMember(details, memberId, clubId);
        clubRepository.updateManager(memberId);
    }

    @Transactional
    public void expelMember(PrincipalDetails details, UUID memberId, Long clubId) {
        checkIsManagerAndTargetIsClubMember(details, memberId, clubId);
        memberClubRepository.deleteMemberClubByClub_IdAndMember_Id(clubId, memberId);
    }

    private void checkIsManagerAndTargetIsClubMember(PrincipalDetails details, UUID memberId, Long clubId) {
        Club club = findClubById(clubId);
        if (!club.getManagerId().toString().equals(details.getUserId())) {
            throw new ClubException(UNAUTHORIZED_ACTION);
        }
        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(memberId, clubId).isEmpty()) {
            throw new MemberClubException(MEMBERCLUB_NOT_FOUND);
        }
    }

    private Club findClubById(Long clubId) {
        return clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );
    }

    public ClubResponse getClub(Long clubId) {
        Club club = findClubById(clubId);
        return new ClubResponse(club);
    }
}
