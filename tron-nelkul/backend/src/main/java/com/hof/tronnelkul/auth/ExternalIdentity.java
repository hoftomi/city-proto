package com.hof.tronnelkul.auth;

/** An identity verified by an external provider. */
public record ExternalIdentity(String provider, String subject, String email, String name) {}
