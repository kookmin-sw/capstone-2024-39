package com.project.capstone.quiz.domain;

import com.project.capstone.book.domain.Book;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface QuizRepository extends JpaRepository<Quiz, Long> {
    Optional<Quiz> findQuizById(Long id);

    List<Quiz> findQuizzesByBook(Book book);
}
