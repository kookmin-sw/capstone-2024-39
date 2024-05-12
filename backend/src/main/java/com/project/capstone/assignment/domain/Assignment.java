package com.project.capstone.assignment.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.capstone.assignment.controller.dto.CreateAssignmentRequest;
import com.project.capstone.club.domain.Club;
import com.project.capstone.content.domain.Content;
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

    @Column(name = "start_date")
    private String startDate;

    @Column(name = "end_date")
    private String endDate;

    @JsonManagedReference
    @OneToMany(mappedBy = "assignment")
    List<Content> contents = new ArrayList<>();

    @JsonBackReference
    @ManyToOne
    private Club club;

    public Assignment(CreateAssignmentRequest request, Club club) {
        this(null, request.name(), request.startDate(), request.endDate(), new ArrayList<>(), club);
    }
}
