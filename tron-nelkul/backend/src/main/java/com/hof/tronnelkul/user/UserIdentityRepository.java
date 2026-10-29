package com.hof.tronnelkul.user;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserIdentityRepository extends JpaRepository<UserIdentity, UUID> {
    Optional<UserIdentity> findByProviderAndSubject(String provider, String subject);

    /** Per user: the sign-in providers (comma separated, sorted) and an e-mail address. */
    @Query(value = "select user_id as userId, string_agg(distinct provider, ',' order by provider) as providers, min(email) as email"
        + " from user_identities where user_id in (:userIds) group by user_id", nativeQuery = true)
    List<IdentitySummary> summarize(Collection<UUID> userIds);

    interface IdentitySummary {
        UUID getUserId();
        String getProviders();
        String getEmail();
    }
}
