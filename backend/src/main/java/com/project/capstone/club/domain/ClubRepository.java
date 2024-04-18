package com.project.capstone.club.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ClubRepository extends JpaRepository<Club, Long> {
    List<Club> findClubsByTopic(String topic);
    List<Club> findClubsByNameContaining(String name);
    Optional<Club> findClubById(Long id);
    @Modifying(clearAutomatically = true)
    @Query("update Club c set c.managerId = :id")
    void updateManager(UUID id);
}
