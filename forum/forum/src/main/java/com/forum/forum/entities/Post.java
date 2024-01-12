package com.forum.forum.entities;

import javax.persistence.*;

import lombok.*;

import java.util.*;

import com.fasterxml.jackson.annotation.*;

import java.time.LocalDate;

@Getter
@Setter
@EqualsAndHashCode
@Entity
@Table(name = "post")

public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private long id;

    @Column(name = "title", nullable = false, unique = true)
    private String title;

    @Column(name = "description", nullable = false, length = 400)
    private String description;

    @Column(name = "typology", nullable = false, length = 12)
    private String typology;

    @Column(name = "creationTime")
    private LocalDate creationTime;

    @Version //Per transazioni concorrenti
    @Column(name = "versioning")
    private int versioning;

    @Column(name = "comments")
    private int comments = 0;

    @JsonIgnore
    @OneToMany(mappedBy = "post", cascade = CascadeType.REMOVE)
    private List<Evaluation> evaluations = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}