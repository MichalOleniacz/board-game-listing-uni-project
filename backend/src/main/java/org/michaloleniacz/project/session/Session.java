package org.michaloleniacz.project.session;

import java.time.Instant;
import java.util.UUID;

public record Session(
        String token,
        UUID userId,
        Instant createdAt,
        Instant expiresAt
) { }
