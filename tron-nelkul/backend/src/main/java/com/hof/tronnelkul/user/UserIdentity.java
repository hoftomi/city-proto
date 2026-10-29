package com.hof.tronnelkul.user;

import jakarta.persistence.*;
import java.util.UUID;

/** Link of an external account (Google, Apple, Discord) to a user. */
@Entity
@Table(name = "user_identities")
public class UserIdentity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "user_id", nullable = false) public UUID userId;
    @Column(nullable = false) public String provider;
    @Column(nullable = false) public String subject;
    public String email;

    protected UserIdentity() {}

    public UserIdentity(UUID userId, String provider, String subject, String email) {
        this.userId = userId; this.provider = provider; this.subject = subject; this.email = email;
    }
}
