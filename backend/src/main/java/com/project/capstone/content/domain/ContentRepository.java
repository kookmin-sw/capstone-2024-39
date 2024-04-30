package com.project.capstone.content.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ContentRepository extends JpaRepository<Content, Long> {
    Optional<Content> findContentById(Long id);
    List<Content> findContentsByType(ContentType type);
}
