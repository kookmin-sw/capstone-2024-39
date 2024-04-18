package com.project.capstone.club.service;

import com.project.capstone.auth.domain.PrincipalDetails;
import com.project.capstone.club.controller.dto.ClubCreateRequest;
import com.project.capstone.club.controller.dto.ClubResponse;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.common.domain.MemberClub;
import com.project.capstone.common.domain.MemberClubRepository;
import com.project.capstone.member.domain.Member;
import com.project.capstone.member.domain.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
        Club savedClub = clubRepository.save(Club.builder()
                .managerId(UUID.fromString(memberId))
                .topic(request.topic())
                .name(request.name())
                .maximum(request.maximum())
                .publicStatus(request.publicStatus())
                .password(request.password())
                .build());

        join(memberId, savedClub.getId());
    }

    public void join(String memberId, Long clubId) {
        Member member = memberRepository.findMemberById(UUID.fromString(memberId)).orElseThrow(
                () -> new RuntimeException("존재하지 않는 멤버입니다.")
        );
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new RuntimeException("존재하지 않는 모임입니다.")
        );
        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(UUID.fromString(memberId), clubId).isPresent()) {
            throw new RuntimeException("이미 가입된 모임입니다.");
        }
        memberClubRepository.save(new MemberClub(null, member, club));
    }

    @Transactional
    public void out(String userId, Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new RuntimeException("존재하지 않는 모임입니다.")
        );
        if (club.getManagerId().toString().equals(userId)) {
            throw new RuntimeException("모임장은 모임을 나갈 수 없습니다. 모임장을 위임해야합니다.");
        }
        memberClubRepository.deleteMemberClubByClub_IdAndMember_Id(clubId, UUID.fromString(userId));
    }

    @Transactional
    public void delegateManager(PrincipalDetails details, UUID memberId, Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new RuntimeException("존재하지 않는 모임입니다.")
        );
        if (!club.getManagerId().toString().equals(details.getUserId())) {
            throw new RuntimeException("해당 클럽의 모임장이 아님");
        }
        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(memberId, clubId).isEmpty()) {
            throw new RuntimeException("위임하려는 멤버가 모임 구성원이 아닙니다.");
        }
        clubRepository.updateManager(memberId);
    }

    @Transactional
    public void expelMember(PrincipalDetails details, UUID memberId, Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new RuntimeException("존재하지 않는 모임입니다.")
        );
        if (!club.getManagerId().toString().equals(details.getUserId())) {
            throw new RuntimeException("해당 클럽의 모임장이 아님");
        }
        if (memberClubRepository.findMemberClubByMember_IdAndClub_Id(memberId, clubId).isEmpty()) {
            throw new RuntimeException("추방하려는 멤버가 모임 구성원이 아닙니다.");
        }
        memberClubRepository.deleteMemberClubByClub_IdAndMember_Id(clubId, memberId);
    }

    public ClubResponse getClub(Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new RuntimeException("해당 모임이 존재하지 않습니다.")
        );
        return new ClubResponse(club);
    }
}
