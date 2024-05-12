package com.project.capstone.assignment.service;

import com.project.capstone.assignment.controller.dto.AssignmentResponse;
import com.project.capstone.assignment.controller.dto.CreateAssignmentRequest;
import com.project.capstone.assignment.domain.Assignment;
import com.project.capstone.assignment.domain.AssignmentRepository;
import com.project.capstone.club.domain.Club;
import com.project.capstone.club.domain.ClubRepository;
import com.project.capstone.club.exception.ClubException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static com.project.capstone.club.exception.ClubExceptionType.CLUB_NOT_FOUND;
import static com.project.capstone.club.exception.ClubExceptionType.UNAUTHORIZED_ACTION;

@Service
@RequiredArgsConstructor
@Slf4j
public class AssignmentService {

    private final ClubRepository clubRepository;
    private final AssignmentRepository assignmentRepository;
    public void createAssignment(String userId, CreateAssignmentRequest request, Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );
        if (!club.getManagerId().toString().equals(userId)) {
            throw new ClubException(UNAUTHORIZED_ACTION);
        }
        assignmentRepository.save(new Assignment(request, club));
    }


    public List<AssignmentResponse> getAssignment(Long clubId) {
        Club club = clubRepository.findClubById(clubId).orElseThrow(
                () -> new ClubException(CLUB_NOT_FOUND)
        );
        List<Assignment> assignmentsByClub = assignmentRepository.findAssignmentsByClub(club);
        List<AssignmentResponse> assignmentResponseList = new ArrayList<>();
        for (Assignment assignment : assignmentsByClub) {
            assignmentResponseList.add(new AssignmentResponse(assignment));
        }
        return assignmentResponseList;
    }
}
