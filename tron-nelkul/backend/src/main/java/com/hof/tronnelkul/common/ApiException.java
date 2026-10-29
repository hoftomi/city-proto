package com.hof.tronnelkul.common;

import com.hof.tronnelkul.game.engine.Msg;
import org.springframework.http.HttpStatus;

/**
 * Error meant for the user. The message is an i18n key with args (server.*, engine.*), resolved by ApiExceptionHandler
 * into ProblemDetail.detail, which the mobile client shows. `code` is an optional machine code (ProblemDetail `code`)
 * the client can act on, e.g. `house_name`: the house name is invalid or taken.
 */
public class ApiException extends RuntimeException {
    public final HttpStatus status;
    public final Msg msg;
    public final String code;

    public ApiException(HttpStatus status, Msg msg) { this(status, msg, null); }

    public ApiException(HttpStatus status, Msg msg, String code) { super(msg.key()); this.status = status; this.msg = msg; this.code = code; }

    public ApiException withCode(String c) { return new ApiException(status, msg, c); }

    public static ApiException badRequest(Msg m) { return new ApiException(HttpStatus.BAD_REQUEST, m); }
    public static ApiException badRequest(String key, Object... args) { return badRequest(Msg.of(key, args)); }
    public static ApiException notFound(String key, Object... args) { return new ApiException(HttpStatus.NOT_FOUND, Msg.of(key, args)); }
    public static ApiException conflict(String key, Object... args) { return new ApiException(HttpStatus.CONFLICT, Msg.of(key, args)); }
    public static ApiException forbidden(String key, Object... args) { return new ApiException(HttpStatus.FORBIDDEN, Msg.of(key, args)); }
    public static ApiException unauthorized(String key, Object... args) { return new ApiException(HttpStatus.UNAUTHORIZED, Msg.of(key, args)); }
}
