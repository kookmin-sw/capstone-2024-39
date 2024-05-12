package com.project.capstone.assignment.domain;

import com.project.capstone.club.domain.Club;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AssignmentRepository extends JpaRepository<Assignment, Long> {
    List<Assignment> findAssignmentsByClub(Club club);

    Optional<Assignment> findAssignmentById(Long id);
}
