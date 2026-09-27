package com.hof.tronnelkul.common;

import com.hof.tronnelkul.game.engine.EngineException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.util.NoSuchElementException;

/** Minden hiba RFC 9457 ProblemDetail formában megy ki; a `detail` mező magyar, megjeleníthető szöveg. */
@RestControllerAdvice
public class ApiExceptionHandler {
    private static final Logger log = LoggerFactory.getLogger(ApiExceptionHandler.class);

    @ExceptionHandler(ApiException.class)
    ProblemDetail api(ApiException e) { return ProblemDetail.forStatusAndDetail(e.status, e.getMessage()); }

    /** Szabálysértés a motorban, ha nem a GameRunner fordította le. */
    @ExceptionHandler(EngineException.class)
    ProblemDetail rule(EngineException e) { return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage()); }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ProblemDetail invalid(MethodArgumentNotValidException e) {
        String msg = e.getBindingResult().getFieldErrors().stream().findFirst()
            .map(f -> f.getDefaultMessage()).orElse("Hibás kérés.");
        return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, msg);
    }

    @ExceptionHandler({HttpMessageNotReadableException.class, MethodArgumentTypeMismatchException.class})
    ProblemDetail unreadable(Exception e) { return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Hibás kérés."); }

    @ExceptionHandler(IllegalArgumentException.class)
    ProblemDetail illegal(IllegalArgumentException e) { return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage()); }

    @ExceptionHandler(NoSuchElementException.class)
    ProblemDetail missing(NoSuchElementException e) { return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, "Nincs ilyen elem."); }

    @ExceptionHandler(Exception.class)
    ProblemDetail other(Exception e) {
        // A Spring MVC saját hibái (404 ismeretlen útvonal, 405, 415 ...) megtartják a státuszukat.
        if (e instanceof ErrorResponse er) return er.getBody();
        log.error("Váratlan hiba", e);
        return ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, "Váratlan hiba történt. Próbáld újra kicsit később.");
    }
}
