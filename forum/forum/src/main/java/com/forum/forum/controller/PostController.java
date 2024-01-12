package com.forum.forum.controller;

import com.forum.forum.services.PostService;
import com.forum.forum.supports.exceptions.PostAlreadyExistsException;
import com.forum.forum.supports.exceptions.PostNotFoundException;
import com.forum.forum.entities.Post;
import com.forum.forum.supports.utility.ResponseMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import javax.validation.Valid;

import org.springframework.web.bind.annotation.PathVariable;


@RestController
@RequestMapping("/post")
public class PostController {
    @Autowired
    private PostService postService;

    @PostMapping("/create")
    public ResponseEntity createPost(@Valid @RequestBody Post post) {
        try {
            postService.createPost(post);
            return ResponseEntity.ok().build();
        } catch (PostAlreadyExistsException e) {
            return new ResponseEntity(new ResponseMessage("ERROR:TITLE_ALREADY_EXISTS"), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/delete/{postId}/{userId}")
    public ResponseEntity delete(@PathVariable("postId") long postId, @PathVariable("userId") long userId) {
        try {
            postService.deletePost(postId, userId);
            return new ResponseEntity<>(new ResponseMessage("SUCCESS"), HttpStatus.OK);
        } catch (PostNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR"), HttpStatus.OK);
        }
    }
}