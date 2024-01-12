package com.forum.forum.entities;

import javax.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Getter
@Setter
@EqualsAndHashCode
@Entity
@Table(name = "evaluation")
public class Evaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private long id;

    @Column(name = "quote", nullable = false)
    private int quote;

    @Column(name = "shortEvaluation", length = 100)
    private String shortEvaluation;

    @Column(name = "evaluationTime")
    private LocalDate evaluationTime;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;
}