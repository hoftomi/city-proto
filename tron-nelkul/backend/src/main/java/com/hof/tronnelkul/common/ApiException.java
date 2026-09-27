package com.hof.tronnelkul.common;

import org.springframework.http.HttpStatus;

/**
 * Felhasználónak szóló hiba. Az üzenet magyarul, a mobil kliens megjeleníti. A `code` opcionális gépi kód
 * (a ProblemDetail `code` mezője), amely alapján a kliens dönthet, például `house_name`: a ház neve hibás vagy foglalt.
 */
public class ApiException extends RuntimeException {
    public final HttpStatus status;
    public final String code;

    public ApiException(HttpStatus status, String message) { this(status, message, null); }

    public ApiException(HttpStatus status, String message, String code) { super(message); this.status = status; this.code = code; }

    public ApiException withCode(String c) { return new ApiException(status, getMessage(), c); }

    public static ApiException badRequest(String m) { return new ApiException(HttpStatus.BAD_REQUEST, m); }
    public static ApiException notFound(String m) { return new ApiException(HttpStatus.NOT_FOUND, m); }
    public static ApiException conflict(String m) { return new ApiException(HttpStatus.CONFLICT, m); }
    public static ApiException forbidden(String m) { return new ApiException(HttpStatus.FORBIDDEN, m); }
    public static ApiException unauthorized(String m) { return new ApiException(HttpStatus.UNAUTHORIZED, m); }
}
