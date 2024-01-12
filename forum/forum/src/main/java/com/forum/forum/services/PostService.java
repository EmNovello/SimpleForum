package com.forum.forum.services;

import com.forum.forum.entities.Post;
import com.forum.forum.entities.User;
import com.forum.forum.repositories.PostRepository;
import com.forum.forum.repositories.UserRepository;
import com.forum.forum.supports.exceptions.PostAlreadyExistsException;
import com.forum.forum.supports.exceptions.PostNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import java.util.*;


@Service
public class PostService {
    @Autowired
    private PostRepository postRepository;
    @Autowired
    private UserRepository userRepository;

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<Post> getPopular(int pageNumber, int pageSize) {
        Pageable paging = PageRequest.of(pageNumber, pageSize);
        Page<Post> pagedResult = postRepository.findPopular(paging);
        if (pagedResult.hasContent())
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<Post> getByUserOrderByComments(String username, int pageNumber, int pageSize) {
        if (!userRepository.existsByUsername(username)) {
            Page<Post> listPost = new PageImpl<>(new ArrayList<>());
            return listPost.getContent();
        }
        User user = userRepository.findByUsername(username);
        Pageable paging = PageRequest.of(pageNumber, pageSize);
        Page<Post> pagRes = postRepository.findByUserId(user.getId(), paging);
        return pagRes.getContent();
    } //Accettabile vuota


    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<Post> getByTitle(String title, int pageNumber, int pageSize) {
        Pageable pag = PageRequest.of(pageNumber, pageSize);
        Page<Post> pagRes = postRepository.findByTitleContaining(title, pag);
        return pagRes.getContent();
    } //Accettabile vuota

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<Post> getByTypology(String typology, int pageNumber, int pageSize) {
        Pageable pag = PageRequest.of(pageNumber, pageSize);
        Page<Post> pagRes = postRepository.findByTypologyOrderByComments(typology, pag);
        return pagRes.getContent();
    } //Accettabile vuota

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Post createPost(Post post) throws PostAlreadyExistsException {
        if (postRepository.existsByTitleIgnoreCase(post.getTitle()))
            throw new PostAlreadyExistsException();
        post.setUser(userRepository.findById(post.getUser().getId()).get());
        postRepository.save(post);
        post.getUser().getPosts().add(post);
        return post;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void deletePost(long postId, long userId) throws PostNotFoundException {
        if (!postRepository.existsById(postId))
            throw new PostNotFoundException();
        Post p = postRepository.findById(postId).get();
        if (p.getUser().getId() != userId)
            throw new PostNotFoundException();
        postRepository.delete(p);
    }
}