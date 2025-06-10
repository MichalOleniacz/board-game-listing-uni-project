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

    @Test
    void shouldMatchExactPath() {
        PathPattern pattern = new PathPattern("/users/list");
        assertTrue(pattern.matches("/users/list"));
        assertFalse(pattern.matches("/users/view"));
        assertFalse(pattern.matches("/users/list/extra"));
        assertFalse(pattern.matches("/users"));
    }

    @Test
    void shouldMatchPathWithParameters() {
        PathPattern pattern = new PathPattern("/users/:id");

        assertTrue(pattern.matches("/users/123"));
        assertTrue(pattern.matches("/users/abc"));
        assertFalse(pattern.matches("/users"));
        assertFalse(pattern.matches("/users/123/details"));
    }

    @Test
    void shouldExtractSinglePathParam() {
        PathPattern pattern = new PathPattern("/users/:id");
        Map<String, String> params = pattern.extractPathParams("/users/42");

        assertEquals(1, params.size());
        assertEquals("42", params.get("id"));
    }

    @Test
    void shouldExtractMultiplePathParams() {
        PathPattern pattern = new PathPattern("/teams/:teamId/users/:userId");
        Map<String, String> params = pattern.extractPathParams("/teams/alpha/users/99");

        assertEquals(2, params.size());
        assertEquals("alpha", params.get("teamId"));
        assertEquals("99", params.get("userId"));
    }

    @Test
    void shouldReturnEmptyParamsWhenNoParamInPattern() {
        PathPattern pattern = new PathPattern("/static/path");
        Map<String, String> params = pattern.extractPathParams("/static/path");

        assertTrue(params.isEmpty());
    }

    @Test
    void shouldHandleLeadingAndTrailingSlashes() {
        PathPattern pattern = new PathPattern("/users/:id/");
        assertTrue(pattern.matches("/users/88"));
        assertTrue(pattern.matches("/users/88/"));
    }

    @Test
    void getRawPathShouldReturnOriginal() {
        String input = "/a/:b/c";
        PathPattern pattern = new PathPattern(input);
        assertEquals(input, pattern.getRawPath());
    }

    @Test
    void shouldNotMatchIfSegmentCountsDiffer() {
        PathPattern pattern = new PathPattern("/a/:id");
        assertFalse(pattern.matches("/a"));
        assertFalse(pattern.matches("/a/id/extra"));
    }

    @Test
    void shouldHandleEmptyPathCorrectly() {
        PathPattern pattern = new PathPattern("/");
        assertTrue(pattern.matches("/"));
        assertFalse(pattern.matches("/something"));
        assertTrue(pattern.extractPathParams("/").isEmpty());
    }
}
