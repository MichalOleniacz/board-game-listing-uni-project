package org.michaloleniacz.project.util.json;

import org.michaloleniacz.project.auth.UserRole;

import java.time.Instant;
import java.util.*;
import java.lang.reflect.*;

public class JsonUtil {
    public static String toJson(Object obj) {
        if (obj == null) return "null";
        if (obj instanceof String s) return '"' + escape(s) + '"';
        if (obj instanceof UUID uuid) return '"' + uuid.toString() + '"';
        if (obj instanceof Instant instant) return '"' + instant.toString() + '"';
        if (obj instanceof Number || obj instanceof Boolean) return obj.toString();
        if (obj instanceof java.sql.Date sqlDate) {
            return '"' + sqlDate.toLocalDate().toString() + '"'; // ISO format (e.g. 2024-06-04)
        }
        if (obj instanceof java.util.Date date) {
            return '"' + date.toInstant().toString() + '"'; // ISO 8601 with time
        }
        if (obj instanceof UserRole role) {
            return '"' + role.toString() + '"';
        }
        if (obj instanceof Map<?, ?> map) return serializeMap(map);
        if (obj instanceof List<?> list) return serializeList(list);
        if (obj.getClass().isArray()) return serializeArray((Object[]) obj);

        return serializeObject(obj);
    }

//    public static <T> List<T> mapToRecordList(List<Object> rawList, Class<T> type) {
//        List<T> result = new ArrayList<>();
//        for (Object item : rawList) {
//            if (!(item instanceof Map<?, ?> map)) {
//                throw new BadRequestException("Expected object in list for type " + type.getSimpleName());
//            }
//            result.add(mapToRecord((Map<String, Object>) map, type));
//        }
//        return result;
//    }
//
//    public static <T> PaginatedResult<T> parsePaginatedResult(String json, Class<T> innerType) {
//        Map<String, Object> map = parseJsonToMap(json);
//
//        int pageSize = (int) map.get("pageSize");
//        int pageNumber = (int) map.get("pageNumber");
//        int currentOffset = (int) map.get("currentOffset");
//
//        List<Object> rawList = (List<Object>) map.get("result");
//        List<T> result = JsonMapper.mapToRecordList(rawList, innerType);
//
//        return new PaginatedResult<>(result, pageSize, currentOffset, pageNumber);
//    }

    public static Map<String, Object> parseJsonToMap(String json) {
        Map<String, Object> map = new HashMap<>();
        json = json.trim();
        if (json.startsWith("{") && json.endsWith("}")) {
            json = json.substring(1, json.length() - 1).trim();
        }

        List<String> entries = splitJsonEntries(json);
        for (String entry : entries) {
            String[] parts = entry.split(":", 2);
            if (parts.length == 2) {
                String key = parts[0].trim().replaceAll("^\"|\"$", "");
                String value = parts[1].trim();
                map.put(key, parseJsonValue(value));
            }
        }
        return map;
    }

    private static List<String> splitJsonEntries(String json) {
        List<String> entries = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean inQuotes = false;
        int depth = 0;

        for (int i = 0; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '"') inQuotes = !inQuotes;
            if (!inQuotes) {
                if (c == '{' || c == '[') depth++;
                else if (c == '}' || c == ']') depth--;
            }
            if (c == ',' && !inQuotes && depth == 0) {
                entries.add(sb.toString().trim());
                sb.setLength(0);
            } else {
                sb.append(c);
            }
        }
        if (sb.length() > 0) entries.add(sb.toString().trim());
        return entries;
    }


    private static Object parseJsonValue(String value) {
        value = value.trim();

        if (value.startsWith("\"") && value.endsWith("\"")) {
            return value.substring(1, value.length() - 1);
        }

        if (value.startsWith("[") && value.endsWith("]")) {
            return parseJsonArray(value);
        }

        if ("true".equals(value) || "false".equals(value)) {
            return Boolean.parseBoolean(value);
        }

        try {
            if (value.contains(".")) return Double.parseDouble(value);
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return value;
        }
    }

    private static List<Object> parseJsonArray(String json) {
        List<Object> list = new ArrayList<>();
        json = json.substring(1, json.length() - 1).trim(); // strip [ ]

        if (json.isEmpty()) return list;

        List<String> elements = splitJsonEntries(json); // reuse existing safe splitter
        for (String elem : elements) {
            list.add(parseJsonValue(elem.trim()));
        }
        return list;
    }


    private static String serializeObject(Object obj) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        boolean first = true;

        try {
            if (obj.getClass().isRecord()) {
                for (RecordComponent rc : obj.getClass().getRecordComponents()) {
                    Object value = rc.getAccessor().invoke(obj);
                    if (!first) sb.append(",");
                    sb.append('"').append(rc.getName()).append('"').append(":").append(toJson(value));
                    first = false;
                }
            } else {
                for (Field field : obj.getClass().getDeclaredFields()) {
                    field.setAccessible(true);
                    Object value = field.get(obj);
                    if (!first) sb.append(",");
                    sb.append('"').append(field.getName()).append('"').append(":").append(toJson(value));
                    first = false;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to serialize object", e);
        }

        sb.append("}");
        return sb.toString();
    }

    private static String serializeMap(Map<?, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;

        for (Map.Entry<?, ?> entry : map.entrySet()) {
            Object key = entry.getKey();
            Object value = entry.getValue();
            if (!(key instanceof String)) continue; // skip non-string keys

            if (!first) sb.append(",");
            sb.append("\"").append(escape((String) key)).append("\":").append(toJson(value));
            first = false;
        }

        sb.append("}");
        return sb.toString();
    }

    private static String serializeList(List<?> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append(toJson(list.get(i)));
            if (i < list.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private static String serializeArray(Object[] array) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < array.length; i++) {
            sb.append(toJson(array[i]));
            if (i < array.length - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private static String escape(String s) {
        return s.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
