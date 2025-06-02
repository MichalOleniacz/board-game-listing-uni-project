package org.michaloleniacz.project.util.passwordHasher.impl;

import org.michaloleniacz.project.util.Logger;
import org.michaloleniacz.project.util.passwordHasher.PasswordHasherStrategy;

public class PlaintextPasswordHasherImpl implements PasswordHasherStrategy {
    @Override
    public String hash(String password) {
        Logger.warn("Plain text password hasher strategy used.");
        return password;
    }
}
