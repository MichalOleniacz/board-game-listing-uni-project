package org.michaloleniacz.project.util.json;

import org.junit.jupiter.api.Test;
import org.michaloleniacz.project.util.json.JsonUtil;

import java.time.Instant;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class JsonUtilTest {

    public static record User(String name, int age) {}
    public static record Container(List<Object> values) {}

    @Test
    void testToJson_stringEscaping() {
        assertEquals("\"hello\"", JsonUtil.toJson("hello"));
        assertEquals("\"line\\nbreak\"", JsonUtil.toJson("line\nbreak"));
        assertEquals("\"quote\\\"test\"", JsonUtil.toJson("quote\"test"));
    }

    @Test
    void testToJson_primitives() {
        assertEquals("123", JsonUtil.toJson(123));
        assertEquals("true", JsonUtil.toJson(true));
        assertEquals("45.67", JsonUtil.toJson(45.67));
        assertEquals("null", JsonUtil.toJson(null));
    }

    @Test
    void testToJson_uuidAndInstant() {
        UUID uuid = UUID.randomUUID();
        Instant now = Instant.now();

        assertEquals('"' + uuid.toString() + '"', JsonUtil.toJson(uuid));
        assertEquals('"' + now.toString() + '"', JsonUtil.toJson(now));
    }

    @Test
    void testToJson_recordObject() {
        String json = JsonUtil.toJson(new User("Alice", 28));
        assertTrue(json.contains("\"name\":\"Alice\""));
        assertTrue(json.contains("\"age\":28"));
    }

    @Test
    void testToJson_map() {
        Map<String, Object> map = Map.of("x", 1, "y", "val");
        String json = JsonUtil.toJson(map);
        assertTrue(json.contains("\"x\":1"));
        assertTrue(json.contains("\"y\":\"val\""));
    }

    @Test
    void testToJson_list() {
        List<Object> list = List.of("a", 2, true);
        String json = JsonUtil.toJson(list);
        assertEquals("[\"a\",2,true]", json);
    }

    @Test
    void testToJson_array() {
        Object[] arr = {"foo", 42, false};
        String json = JsonUtil.toJson(arr);
        assertEquals("[\"foo\",42,false]", json);
    }

    @Test
    void testParseJsonToMap() {
        String json = "{\"name\":\"Bob\",\"age\":42,\"active\":true}";
        Map<String, Object> map = JsonUtil.parseJsonToMap(json);
        assertEquals("Bob", map.get("name"));
        assertEquals(42, map.get("age"));
        assertEquals(true, map.get("active"));
    }

    @Test
    void testParseNestedListAndArray() {
        String json = "{\"values\":[\"x\",2,false]}";
        Map<String, Object> map = JsonUtil.parseJsonToMap(json);
        assertTrue(map.get("values") instanceof List<?> list);
        assertEquals(List.of("x", 2, false), map.get("values"));
    }

    @Test
    void testParseEmptyJsonObject() {
        Map<String, Object> map = JsonUtil.parseJsonToMap("{}");
        assertTrue(map.isEmpty());
    }

    @Test
    void testParseInvalidJsonValueFallsBackToString() {
        String json = "{\"foo\":notQuoted}";
        Map<String, Object> map = JsonUtil.parseJsonToMap(json);
        assertEquals("notQuoted", map.get("foo"));
    }
}
