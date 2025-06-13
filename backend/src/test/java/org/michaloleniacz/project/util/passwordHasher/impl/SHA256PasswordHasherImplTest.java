package org.michaloleniacz.project.util.passwordHasher.impl;

import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import static org.junit.jupiter.api.Assertions.*;

class SHA256PasswordHasherImplTest {

    private final String salt = "testSalt";
    private final SHA256PasswordHasherImpl hasher = new SHA256PasswordHasherImpl(salt);

    @Test
    void shouldHashPasswordConsistently() throws Exception {
        String password = "secretPassword";

        String expectedHash = computeExpectedSHA256(salt, password);
        String actualHash = hasher.hash(password);

        assertEquals(expectedHash, actualHash);
    }

    @Test
    void shouldReturnDifferentHashForDifferentSalts() {
        String password = "password123";

        SHA256PasswordHasherImpl hasher1 = new SHA256PasswordHasherImpl("saltOne");
        SHA256PasswordHasherImpl hasher2 = new SHA256PasswordHasherImpl("saltTwo");

        String hash1 = hasher1.hash(password);
        String hash2 = hasher2.hash(password);

        assertNotEquals(hash1, hash2);
    }

    @Test
    void shouldReturnSameHashForSameSaltAndPassword() {
        String password = "abc123";

        SHA256PasswordHasherImpl hasher1 = new SHA256PasswordHasherImpl("mysalt");
        SHA256PasswordHasherImpl hasher2 = new SHA256PasswordHasherImpl("mysalt");

        String hash1 = hasher1.hash(password);
        String hash2 = hasher2.hash(password);

        assertEquals(hash1, hash2);
    }

    @Test
    void shouldThrowInternalServerErrorExceptionForInvalidAlgorithm() {
        SHA256PasswordHasherImpl faulty = new SHA256PasswordHasherImpl("salt") {
            @Override
            public String hash(String password) {
                try {
                    MessageDigest.getInstance("invalid-algo");
                    return "should not reach";
                } catch (Exception e) {
                    throw new InternalServerErrorException("Hashing failed: " + e.getMessage());
                }
            }
        };

        InternalServerErrorException ex = assertThrows(
                InternalServerErrorException.class,
                () -> faulty.hash("pass")
        );

        assertTrue(ex.getMessage().contains("Hashing failed"));
    }

    // Helper to compute expected SHA-256 hash
    private String computeExpectedSHA256(String salt, String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt.getBytes(StandardCharsets.UTF_8));
        byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}
