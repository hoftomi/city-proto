package com.hof.tronnelkul.user;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "users")
public class AppUser {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = "display_name", nullable = false) private String displayName;
    @Column(nullable = false) private String role = "PLAYER";
    @Column(name = "created_at", nullable = false) private Instant createdAt = Instant.now();

    public AppUser(String displayName, String role) { this.displayName = displayName; this.role = role; }
}
