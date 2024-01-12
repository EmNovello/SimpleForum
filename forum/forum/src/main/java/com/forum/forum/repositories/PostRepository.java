package com.forum.forum.repositories;

import org.springframework.stereotype.Repository;
import com.forum.forum.entities.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    boolean existsByTitleIgnoreCase(String title);

    @Query("select p from Post p order by p.creationTime desc")
    Page<Post> findPopular(Pageable pageable);

    @Query("select p from Post p where p.user.id = :userId order by p.creationTime desc")
    Page<Post> findByUserId(@Param("userId") long userId, Pageable pageable);

    Page<Post> findByTitleContaining(String title, Pageable pageable);

    Page<Post> findByTypologyOrderByComments(String typology, Pageable pageable);
}
