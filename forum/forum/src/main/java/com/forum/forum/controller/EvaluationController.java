package com.forum.forum.controller;

import com.forum.forum.services.EvaluationService;
import com.forum.forum.supports.exceptions.QuoteWrongException;
import com.forum.forum.supports.exceptions.EvaluationsNotFoundExceptions;
import com.forum.forum.entities.Evaluation;
import com.forum.forum.supports.utility.ResponseMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/evaluation")
public class EvaluationController {
    @Autowired
    private EvaluationService evaluationService;
    @Value("${pageSize}")
    private int pageSize;

    @PostMapping("/create")
    public ResponseEntity newEvaluation(@Valid @RequestBody Evaluation evaluation) {
        try {
            evaluationService.createEvaluation(evaluation);
            return ResponseEntity.ok().build();
        } catch (QuoteWrongException e) {
            return new ResponseEntity(new ResponseMessage("ERROR:Wrong_quote"), HttpStatus.BAD_REQUEST);
        } catch (EvaluationsNotFoundExceptions e) {
            return new ResponseEntity(new ResponseMessage("ERROR:Already_valutated"), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/delete/{postId}/{userId}")
    public ResponseEntity delete(@PathVariable("postId") long postId, @PathVariable("userId") long userId) {
        try {
            evaluationService.deleteEvaluation(postId, userId);
            return new ResponseEntity<>(new ResponseMessage("SUCCESS"), HttpStatus.OK);
        } catch (EvaluationsNotFoundExceptions e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR:NO_EVALUATION"), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/evaluations/{postId}")
    public ResponseEntity getEvaluationsByPostId(@PathVariable("postId") long postId, @RequestParam int pageNumber) {
        List<Evaluation> result = evaluationService.getByPostId(postId, pageNumber, pageSize);
        return new ResponseEntity<>(result, HttpStatus.OK);
    } //Accettabile vuota
}