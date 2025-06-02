package org.michaloleniacz.project.util.passwordHasher;

import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.util.passwordHasher.impl.PlaintextPasswordHasherImpl;
import org.michaloleniacz.project.util.passwordHasher.impl.SHA256PasswordHasherImpl;

public class PasswordHasherFactory {
    public static PasswordHasherStrategy createPasswordHasher() {
        AppConfig config = AppConfig.getInstance();
        String hashStrategy = config.getOrDefault("security.password.hash.algorithm", "sha256").toString();
        String salt = config.getOrDefault("security.password.salt", "").toString();

        switch (hashStrategy) {
            case "sha256":
                return new SHA256PasswordHasherImpl(salt);
            case "plaintext":
                return new PlaintextPasswordHasherImpl();
            default:
                return new PlaintextPasswordHasherImpl();
        }
    }
}
