package com.hof.tronnelkul.user;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "users")
public class AppUser {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "display_name", nullable = false) public String displayName;
    @Column(nullable = false) public String role = "PLAYER";
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected AppUser() {}

    public AppUser(String displayName, String role) { this.displayName = displayName; this.role = role; }
}
