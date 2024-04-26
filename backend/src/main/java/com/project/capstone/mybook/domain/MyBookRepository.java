package com.project.capstone.mybook.domain;

import com.project.capstone.member.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MyBookRepository extends JpaRepository<MyBook, Long> {
    List<MyBook> findMyBooksByMember(Member member);
}
