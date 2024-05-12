package com.project.capstone.assignment.domain;

import com.project.capstone.club.domain.Club;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AssignmentRepository extends JpaRepository<Assignment, Long> {
    List<Assignment> findAssignmentsByClub(Club club);
}
