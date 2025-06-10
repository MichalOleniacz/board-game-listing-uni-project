package org.michaloleniacz.project.util.json;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.function.Executable;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.util.json.JsonMapper;

import java.time.Instant;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class JsonMapperTest {

    record TestRecord(String name, int age, UUID id, Instant created) {}

    @Test
    void shouldMapValidMapToRecord() {
        UUID id = UUID.randomUUID();
        Instant now = Instant.now();

        Map<String, Object> input = Map.of(
                "name", "Alice",
                "age", 30,
                "id", id.toString(),
                "created", now.toString()
        );

        TestRecord result = JsonMapper.mapToRecord(input, TestRecord.class);

        assertEquals("Alice", result.name());
        assertEquals(30, result.age());
        assertEquals(id, result.id());
        assertEquals(now, result.created());
    }

    @Test
    void shouldThrowIfTypeIsNotRecord() {
        class NotARecord {}

        Map<String, Object> map = new HashMap<>();
        assertThrows(IllegalArgumentException.class, () -> JsonMapper.mapToRecord(map, NotARecord.class));
    }

    @Test
    void shouldThrowIfMissingField() {
        Map<String, Object> map = Map.of("name", "Alice", "age", 30); // missing 'id' and 'created'

        Executable executable = () -> JsonMapper.mapToRecord(map, TestRecord.class);
        BadRequestException ex = assertThrows(BadRequestException.class, executable);
        assertTrue(ex.getMessage().contains("Missing field"));
    }

    @Test
    void shouldThrowOnInvalidFieldType() {
        Map<String, Object> map = Map.of(
                "name", "Alice",
                "age", "not-an-int", // Invalid
                "id", UUID.randomUUID().toString(),
                "created", Instant.now().toString()
        );

        assertThrows(BadRequestException.class, () -> JsonMapper.mapToRecord(map, TestRecord.class));
    }

    @Test
    void shouldParseUUIDFromString() {
        String uuidStr = UUID.randomUUID().toString();
        Object result = invokeCast("id", uuidStr, UUID.class);
        assertTrue(result instanceof UUID);
        assertEquals(UUID.fromString(uuidStr), result);
    }

    @Test
    void shouldParseListOfIntegers() {
        Map<String, Object> input = Map.of("numbers", List.of(1, 2, "3"));

        record ListHolder(List<Integer> numbers) {}

        ListHolder holder = JsonMapper.mapToRecord(input, ListHolder.class);
        assertEquals(List.of(1, 2, 3), holder.numbers());
    }

    @Test
    void shouldThrowOnNonListForListField() {
        Map<String, Object> input = Map.of("numbers", "not-a-list");

        record ListHolder(List<Integer> numbers) {}

        assertThrows(BadRequestException.class, () -> JsonMapper.mapToRecord(input, ListHolder.class));
    }

    // Utility to invoke private static method
    private Object invokeCast(String name, Object value, Class<?> type) {
        try {
            var method = JsonMapper.class.getDeclaredMethod("castValue", String.class, Object.class, Class.class);
            method.setAccessible(true);
            return method.invoke(null, name, value, type);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
