package com.forum.forum.repositories;

import org.springframework.stereotype.Repository;

import java.util.*;

import com.forum.forum.entities.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

@Repository
public interface EvaluationRepository extends JpaRepository<Evaluation, Long> {

    Evaluation findByPostIdAndUserId(long postId, long userId);
    Page<Evaluation> findByPostId(long id, Pageable pageable);

    List<Evaluation> findByPostId(long id);

}