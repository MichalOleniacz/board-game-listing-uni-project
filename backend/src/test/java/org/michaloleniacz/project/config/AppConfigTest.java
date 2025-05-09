package org.michaloleniacz.project.config;

import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class AppConfigTest {
    @Test
    void shouldReturnConfiguredValue() {
        String port = AppConfig.getInstance().get("server.port");
        assertNotNull(port);
    }

    @Test
    void shouldReturnDefaultValueWhenKeyMissing() {
        String val = (String) AppConfig.getInstance().getOrDefault("does.not.exist", "fallback");
        assertEquals("fallback", val);
    }

    @Test
    void shouldParseIntCorrectlyOrReturnDefault() {
        int threads = AppConfig.getInstance().getInt("server.threads", 8);
        assertTrue(threads > 0);
    }
}
