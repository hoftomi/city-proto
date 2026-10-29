package com.hof.tronnelkul.user;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.UUID;

/** Link of an external account (Google, Apple, Discord) to a user. */
@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "user_identities")
public class UserIdentity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = "user_id", nullable = false) private UUID userId;
    @Column(nullable = false) private String provider;
    @Column(nullable = false) private String subject;
    private String email;

    public UserIdentity(UUID userId, String provider, String subject, String email) {
        this.userId = userId; this.provider = provider; this.subject = subject; this.email = email;
    }
}
