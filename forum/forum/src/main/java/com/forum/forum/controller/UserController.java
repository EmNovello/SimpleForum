package com.forum.forum.controller;

import com.forum.forum.services.UserService;
import com.forum.forum.supports.exceptions.UserNotFoundException;
import com.forum.forum.supports.exceptions.UserAlreadyExistsByEmailException;
import com.forum.forum.supports.exceptions.UserAlreadyExistsByUsernameException;
import com.forum.forum.entities.User;
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
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity registerUser(@Valid @RequestBody User user) {
        try {
            userService.registerUser(user);
            return ResponseEntity.ok().build();
        } catch (UserAlreadyExistsByEmailException e) {
            return new ResponseEntity(new ResponseMessage("ERROR:email_already_exists"), HttpStatus.BAD_REQUEST);
        } catch (UserAlreadyExistsByUsernameException e) {
            return new ResponseEntity(new ResponseMessage("ERROR:username_already_taken"), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/delete/{userId}")
    public ResponseEntity delete(@PathVariable("userId") long userId) {
        try {
            userService.deleteUser(userId);
            return new ResponseEntity<>(new ResponseMessage("SUCCESS"), HttpStatus.OK);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR"), HttpStatus.NOT_FOUND);
        }
    }
}