package org.michaloleniacz.project.util.passwordHasher;

public interface PasswordHasherStrategy {
    public String hash(String password);
}
