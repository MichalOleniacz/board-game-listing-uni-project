package org.michaloleniacz.project.http.utils;

import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class PathPatternTest {
    @Test
    void shouldMatchStaticPathExactly() {
        PathPattern pattern = new PathPattern("/users");
        assertTrue(pattern.matches("/users"));
        assertFalse(pattern.matches("/users/123"));
    }

    @Test
    void shouldMatchParameterizedPath() {
        PathPattern pattern = new PathPattern("/users/:id");
        assertTrue(pattern.matches("/users/123"));
        assertEquals("123", pattern.extractPathParams("/users/123").get("id"));
    }

    @Test
    void shouldExtractMultipleParams() {
        PathPattern pattern = new PathPattern("/users/:uid/reviews/:rid");
        Map<String, String> params = pattern.extractPathParams("/users/42/reviews/7");
        assertEquals("42", params.get("uid"));
        assertEquals("7", params.get("rid"));
    }
}
