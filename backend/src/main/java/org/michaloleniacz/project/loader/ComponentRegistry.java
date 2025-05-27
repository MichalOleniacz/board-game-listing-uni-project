package org.michaloleniacz.project.loader;

import org.michaloleniacz.project.util.Logger;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ComponentRegistry {
    private static final Map<Class<?>, Object> components = new ConcurrentHashMap<>();

    public static <T> T get(final Class<T> clazz) {
        final Object component = components.get(clazz);
        if (component == null) {
            throw new IllegalStateException("No component found for class: " + clazz.getName());
        }
        return clazz.cast(component);
    }

    public static <T> void register(final Class<T> clazz, final T component) {
        Logger.debug("Registering component " + clazz.getSimpleName());
        if (components.containsKey(clazz)) {
            throw new IllegalStateException("Component " + clazz.getSimpleName() + " already registered");
        }
        components.put(clazz, component);
    }

    public static <T> void unregister(final Class<T> clazz) {
        Logger.debug("Unregistering component " + clazz.getSimpleName());
        components.remove(clazz);
    }

    public static <T> void override(final Class<T> clazz, final T component) {
        Logger.debug("Overriding component " + clazz.getSimpleName());
        components.put(clazz, component);
    }

    public static void clear() {
        Logger.debug("Clearing components");
        components.clear();
    }
}
