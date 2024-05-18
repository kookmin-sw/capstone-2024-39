package com.project.capstone.book.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface BookRepository extends JpaRepository<Book, Long> {
    Optional<Book> findBookById(Long id);
    Optional<Book> findBookByIsbn(String isbn);
    List<Book> findBooksByTitleContaining(String title);
    @Query(value = "select isbn from Book order by rand() limit 10")
    List<String> findBooksByRandom();
    void deleteBookById(Long id);
}
