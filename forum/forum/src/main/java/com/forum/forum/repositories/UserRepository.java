package com.forum.forum.repositories;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import com.forum.forum.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByUsername(String username);

    User findByUsername(String username);

    @Query("select u from User u where u.id!=16")
    Page<User> TakeAll(Pageable pageable);

    Page<User> findByUsernameContaining(String username, Pageable pageable);

    boolean existsByEmail(String email);

    User findByEmail(String email);
}