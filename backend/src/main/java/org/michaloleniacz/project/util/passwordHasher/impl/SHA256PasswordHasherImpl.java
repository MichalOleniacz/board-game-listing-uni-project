package org.michaloleniacz.project.util.passwordHasher.impl;

import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.util.passwordHasher.PasswordHasherStrategy;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class SHA256PasswordHasherImpl implements PasswordHasherStrategy {
    private final String salt;

    public SHA256PasswordHasherImpl(String salt) {
        this.salt = salt;
    }

    @Override
    public String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt.getBytes(StandardCharsets.UTF_8));
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (Exception e) {
            throw new InternalServerErrorException("Hashing failed: " + e.getMessage());
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
