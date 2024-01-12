package com.forum.forum.controller;

import com.forum.forum.services.UserService;
import com.forum.forum.supports.exceptions.PostNotFoundException;
import com.forum.forum.supports.exceptions.UserNotFoundException;
import com.forum.forum.entities.User;
import com.forum.forum.entities.Post;
import com.forum.forum.services.PostService;
import com.forum.forum.supports.utility.ResponseMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.*;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/search")
public class SearchingController {
    @Autowired
    private UserService userService;
    @Autowired
    private PostService postService;
    @Value("${pageSize}")
    private int pageSize;

    @GetMapping("/user")
    public ResponseEntity getByEmail(String email) {
        try {
            User result = userService.getByEmail(email);
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR:User_not_found"), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/users")
    public ResponseEntity getAllUsers(@RequestParam int pageNumber) {
        List<User> result = userService.getAllUsers(pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota

    @GetMapping("/user/username")
    public ResponseEntity getUsersByUsername(@RequestParam String username, @RequestParam int pageNumber) {
        List<User> result = userService.getByUsernameContaining(username, pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota

    @GetMapping("/posts/populars")
    public ResponseEntity getPostsPopular(@RequestParam int pageNumber) {
        List<Post> result = postService.getPopular(pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota

    @GetMapping("/posts/username")
    public ResponseEntity getPostsUsername(@RequestParam String username, @RequestParam int pageNumber) {
        List<Post> result = postService.getByUserOrderByComments(username, pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota

    @GetMapping("/posts/title")
    public ResponseEntity getPostsByTitle(@RequestParam String title, @RequestParam int pageNumber) {
        List<Post> result = postService.getByTitle(title, pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota

    @GetMapping("/posts/typology")
    public ResponseEntity getPostsByTypology(@RequestParam String typology, @RequestParam int pageNumber) {
        List<Post> result = postService.getByTypology(typology, pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota
}