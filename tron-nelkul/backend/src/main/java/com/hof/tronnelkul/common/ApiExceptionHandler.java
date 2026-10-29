package com.hof.tronnelkul.common;

import com.hof.tronnelkul.game.engine.EngineException;
import com.hof.tronnelkul.i18n.Messages;
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

/** Every error goes out as an RFC 9457 ProblemDetail; `detail` is displayable text (i18n, server.* / engine.*). */
@RestControllerAdvice
public class ApiExceptionHandler {
    private static final Logger log = LoggerFactory.getLogger(ApiExceptionHandler.class);
    private final Messages messages;

    public ApiExceptionHandler(Messages messages) { this.messages = messages; }

    @ExceptionHandler(ApiException.class)
    ProblemDetail api(ApiException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(ex.status, messages.text(ex.msg));
        if (ex.code != null) {
            problem.setProperty("code", ex.code);
        }
        return problem;
    }

    /** Rule violation in the engine, if GameRunner did not translate it. */
    @ExceptionHandler(EngineException.class)
    ProblemDetail rule(EngineException ex) { return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, messages.text(ex.msg())); }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ProblemDetail invalid(MethodArgumentNotValidException ex) {
        String msg = ex.getBindingResult().getFieldErrors().stream().findFirst()
            .map(fieldError -> fieldError.getDefaultMessage()).orElseGet(() -> messages.text("server.bad_request"));
        return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, msg);
    }

    @ExceptionHandler({HttpMessageNotReadableException.class, MethodArgumentTypeMismatchException.class})
    ProblemDetail unreadable(Exception ex) { return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, messages.text("server.bad_request")); }

    @ExceptionHandler(IllegalArgumentException.class)
    ProblemDetail illegal(IllegalArgumentException ex) { return ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, ex.getMessage()); }

    @ExceptionHandler(NoSuchElementException.class)
    ProblemDetail missing(NoSuchElementException ex) { return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, messages.text("server.not_found")); }

    @ExceptionHandler(Exception.class)
    ProblemDetail other(Exception ex) {
        // Spring MVC's own errors (404 unknown path, 405, 415 ...) keep their status.
        if (ex instanceof ErrorResponse errorResponse) {
            return errorResponse.getBody();
        }
        log.error("Unexpected error", ex);
        return ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, messages.text("server.unexpected"));
    }
}
