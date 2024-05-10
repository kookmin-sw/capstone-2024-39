package com.project.capstone.content.domain;

import com.project.capstone.book.domain.Book;
import com.project.capstone.club.domain.Club;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ContentRepository extends JpaRepository<Content, Long> {
    Optional<Content> findContentById(Long id);
    List<Content> findContentsByTypeAndClub(ContentType type, Club club);

    List<Content> findContentsByTypeAndBook(ContentType type, Book book);
}
