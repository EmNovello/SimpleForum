package com.forum.forum.services;

import com.forum.forum.entities.Evaluation;
import com.forum.forum.repositories.EvaluationRepository;
import com.forum.forum.entities.Post;
import com.forum.forum.repositories.PostRepository;
import com.forum.forum.repositories.UserRepository;
import com.forum.forum.supports.exceptions.QuoteWrongException;
import com.forum.forum.supports.exceptions.EvaluationsNotFoundExceptions;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Page;
import java.util.*;


@Service
public class EvaluationService {
    @Autowired
    private EvaluationRepository evaluationRepository;
    @Autowired
    private PostRepository postRepository;
    @Autowired
    private UserRepository userRepository;

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<Evaluation> getByPostId(long postId, int pageNumber, int pageSize) {
        Pageable pag = PageRequest.of(pageNumber, pageSize);
        Page<Evaluation> pagRes = evaluationRepository.findByPostId(postId, pag);
        return pagRes.getContent();  //Accettabile vuota
    }

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<Evaluation> getByPostId(long postId) {
        return evaluationRepository.findByPostId(postId); //Accettabile vuota
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Evaluation createEvaluation(Evaluation evaluation) throws EvaluationsNotFoundExceptions, QuoteWrongException {
        if (evaluation.getQuote() > 5 || evaluation.getQuote() <= 0)
            throw new QuoteWrongException();
        long postId = evaluation.getPost().getId();
        long userId = evaluation.getUser().getId();

        Evaluation evaluation1= evaluationRepository.findByPostIdAndUserId(postId, userId);
        if(evaluation1!=null)
            throw new EvaluationsNotFoundExceptions();

        /*List<Evaluation> evaluations = getByPostId(postId);
        if (!evaluations.isEmpty()) {
            for (Evaluation e : evaluations) {
                long id = e.getUser().getId();
                if (id == userId)
                    throw new EvaluationsNotFoundExceptions();
            }
        }*/
        evaluation.setUser(userRepository.findById(evaluation.getUser().getId()).get());
        evaluation.setPost(postRepository.findById(evaluation.getPost().getId()).get());
        evaluationRepository.save(evaluation);
        evaluation.getUser().getEvaluations().add(evaluation);
        evaluation.getPost().getEvaluations().add(evaluation);
        Post post = evaluation.getPost();
        post.setComments(post.getComments() + 1);
        return evaluation;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void deleteEvaluation(long postId, long userId) throws EvaluationsNotFoundExceptions {
        List<Evaluation> evaluations = evaluationRepository.findByPostId(postId);
        for (Evaluation e : evaluations)
            if (e.getUser().getId() == userId) {
                Post post = e.getPost();
                post.setComments(post.getComments() - 1);
                evaluationRepository.delete(e);
                return;
            }
        throw new EvaluationsNotFoundExceptions();
    }
}
