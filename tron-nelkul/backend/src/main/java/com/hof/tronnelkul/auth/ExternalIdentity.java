package com.hof.tronnelkul.auth;

/** Egy külső szolgáltatótól ellenőrzött azonosító. */
public record ExternalIdentity(String provider, String subject, String email, String name) {}
