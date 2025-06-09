package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.persistance.core.JdbcPostgresAdapter;
import org.michaloleniacz.project.persistance.domain.PreferenceRepository;
import org.michaloleniacz.project.preference.dto.PreferenceDto;

import java.util.ArrayList;
import java.util.UUID;

public class PostgresPreferenceRepositoryImpl implements PreferenceRepository {
    private JdbcPostgresAdapter jdbcAdapter;
    private static final int PAGE_SIZE = 100;

    public PostgresPreferenceRepositoryImpl() {
        jdbcAdapter = new JdbcPostgresAdapter();
    }

    @Override
    public void addPreference(UUID userId, int preferenceId) {
        jdbcAdapter.update(
                "INSERT INTO user_preference (userid, preferenceid) VALUES (?, ?)",
                stmt -> {
                    stmt.setString(1, userId.toString());
                    stmt.setInt(2, preferenceId);
                }
        );
    };

    @Override
    public void removePreference(UUID userId, int preferenceId) {
        jdbcAdapter.update(
                "DELETE FROM user_preference WHERE userId = CAST(? AS UUID) AND preferenceId = ?",
                stmt -> {
                    stmt.setString(1, userId.toString());
                    stmt.setInt(2, preferenceId);
                }
        );
    };

    @Override
    public void registerNewPreference(String preferenceName) {
        jdbcAdapter.update(
                "INSERT INTO categories (preference_name) VALUES (?, ?)",
                stmt -> {
                    stmt.setString(1, preferenceName);
                }
        );
    };

    @Override
    public ArrayList<PreferenceDto> getPreferencesForUser(UUID userId) {
        return jdbcAdapter.<PreferenceDto>queryMany(
                "SELECT * FROM user_preference up JOIN categories p ON up.preferenceid = p.id WHERE userid = CAST(? AS UUID)",
                stmt -> stmt.setString(1, userId.toString()),
                rs -> new PreferenceDto(rs.getInt("preferenceid"), rs.getString("category_name"))
        );
    }

    @Override
    public ArrayList<PreferenceDto> getAllPreferences() {
        return jdbcAdapter.<PreferenceDto>queryMany(
                "SELECT * FROM categories",
                stmt -> {},
                rs -> new PreferenceDto(rs.getInt("id"), rs.getString("name"))
        );
    }
}
