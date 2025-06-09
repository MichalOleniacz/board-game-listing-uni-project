package org.michaloleniacz.project.util.json;

import org.michaloleniacz.project.shared.error.BadRequestException;

import java.lang.reflect.Constructor;
import java.lang.reflect.RecordComponent;
import java.time.Instant;
import java.util.*;

public class JsonMapper {
    public static <T> T mapToRecord(Map<String, Object> map, Class<T> type) {
        if (!type.isRecord()) throw new IllegalArgumentException("Only records supported");

        try {
            RecordComponent[] components = type.getRecordComponents();
            Object[] args = new Object[components.length];

            for (int i = 0; i < components.length; i++) {
                RecordComponent rc = components[i];
                String name = rc.getName();
                Object rawValue = map.get(name);

                if (rawValue == null) {
                    throw new BadRequestException("Missing field: " + name);
                }

                args[i] = castValue(name, rawValue, rc.getType());
            }

            Constructor<T> constructor = type.getDeclaredConstructor(Arrays.stream(components)
                    .map(RecordComponent::getType).toArray(Class[]::new));
            return constructor.newInstance(args);
        } catch (BadRequestException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Failed to map to record: " + type.getSimpleName(), e);
        }
    }

    private static Object castValue(String name, Object value, Class<?> type) {
        if (value == null) return null;

        try {
            if (type == String.class) {
                if (value instanceof String s) return s;
                throw new BadRequestException("Invalid value for field: " + name + ". Expected " + type.getSimpleName());
            }

            if (type == int.class || type == Integer.class) {
                if (value instanceof Number n) return n.intValue();
                return Integer.parseInt(value.toString());
            }

            if (type == Instant.class) {
                return Instant.parse(value.toString());
            }

            if (type == long.class || type == Long.class) {
                if (value instanceof Number n) return n.longValue();
                return Long.parseLong(value.toString());
            }

            if (type == double.class || type == Double.class) {
                if (value instanceof Number n) return n.doubleValue();
                return Double.parseDouble(value.toString());
            }

            if (type == boolean.class || type == Boolean.class) {
                if (value instanceof Boolean b) return b;
                return Boolean.parseBoolean(value.toString());
            }

            if (type == UUID.class) {
                return UUID.fromString(value.toString());
            }

            if (type == ArrayList.class || type == List.class) {
                if (!(value instanceof List<?> rawList)) {
                    throw new BadRequestException("Expected array, got: " + value.getClass().getSimpleName());
                }

                // Try best-effort Integer list
                ArrayList<Integer> casted = new ArrayList<>();
                for (Object item : rawList) {
                    if (item instanceof Number n) casted.add(n.intValue());
                    else casted.add(Integer.parseInt(item.toString()));
                }
                return casted;
            }

            if (type == UUID.class) return UUID.fromString(value.toString());
            if (type == Instant.class) return Instant.parse(value.toString());
            if (type == java.sql.Date.class) return java.sql.Date.valueOf(value.toString());
            if (type == Date.class) return Date.from(Instant.parse(value.toString()));
            if (type == boolean.class || type == Boolean.class) return Boolean.parseBoolean(value.toString());
        } catch (Exception e) {
            throw new BadRequestException("Invalid value for field: " + name + ". Expected " + type.getSimpleName());
        }

        throw new BadRequestException("Invalid value for field: " + name + ". Expected " + type.getSimpleName());
    }

}
