package com.project.capstone.assignment.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.assignment.controller.dto.CreateAssignmentRequest;
import com.project.capstone.club.domain.Club;
import com.project.capstone.content.domain.Content;
import com.project.capstone.content.domain.ContentType;
import com.project.capstone.quiz.domain.Quiz;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Table(name = "assignment")
public class Assignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "assignment_type")
    private AssignmentType assignmentType;

    @Column(name = "start_date")
    private String startDate;

    @Column(name = "end_date")
    private String endDate;

    @JsonManagedReference
    @OneToMany(mappedBy = "assignment")
    List<Content> contents = new ArrayList<>();

    @JsonManagedReference
    @OneToMany(mappedBy = "assignment")
    List<Quiz> quizzes = new ArrayList<>();

    @JsonBackReference
    @ManyToOne
    private Club club;

    public Assignment(CreateAssignmentRequest request, Club club) {
        this(null, request.name(), request.type(), request.startDate(), request.endDate(), new ArrayList<>(), new ArrayList<>(), club);
    }
}
