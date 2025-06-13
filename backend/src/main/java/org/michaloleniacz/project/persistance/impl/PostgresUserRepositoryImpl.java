package org.michaloleniacz.project.persistance.impl;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.user.User;
import org.michaloleniacz.project.persistance.core.JdbcPostgresAdapter;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.user.dto.UserDetailsDto;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;
import java.util.UUID;

public class PostgresUserRepositoryImpl implements UserRepository {

    private JdbcPostgresAdapter jdbcAdapter;
    private static final int PAGE_SIZE = 100;

    public PostgresUserRepositoryImpl() {
        jdbcAdapter = new JdbcPostgresAdapter();
    }

    private UserDto mapUserDto(ResultSet rs) throws SQLException {
        return new UserDto(
                rs.getObject("id", UUID.class),
                rs.getString("username"),
                rs.getString("email"),
                UserRole.valueOf(rs.getString("role"))
        );
    }

    private User mapUser(ResultSet rs) throws SQLException {
        return new User(
                rs.getObject("id", UUID.class),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("password_hash"),
                UserRole.valueOf(rs.getString("role"))
        );
    }

    @Override
    public Optional<UserDto> findById(UUID id) {
        return jdbcAdapter.queryOne(
                "SELECT id, username, email, role FROM users WHERE id = ?",
                stmt -> stmt.setObject(1, id),
                rs -> mapUserDto(rs)
        );
    }

    @Override
    public boolean add(User userEntity) {
        return jdbcAdapter.update(
                "INSERT INTO users (id, username, email, password_hash, role) VALUES (?, ?, ?, ?, ?)",
                stmt -> {
                    stmt.setObject(1, userEntity.id());
                    stmt.setString(2, userEntity.username());
                    stmt.setString(3, userEntity.email());
                    stmt.setString(4, userEntity.passwordHash());
                    stmt.setString(5, userEntity.role().name()); // store as string
                }
        ) > 0;
    }
    @Override
    public boolean addTransactional(User userEntity) {
        return jdbcAdapter.<Boolean>transaction(conn -> {
            return Boolean.valueOf(jdbcAdapter.updateWithConnection(
                    conn,
                    "INSERT INTO users (id, username, email, password_hash, role) VALUES (?, ?, ?, ?, ?)",
                    stmt -> {
                        stmt.setObject(1, userEntity.id());
                        stmt.setString(2, userEntity.username());
                        stmt.setString(3, userEntity.email());
                        stmt.setString(4, userEntity.passwordHash());
                        stmt.setString(5, userEntity.role().name());
                    }
            ) > 0);
        }).booleanValue();
    }

    @Override
    public boolean deleteById(UUID id) {
        jdbcAdapter.update(
                "DELETE FROM users WHERE id = ?",
                stmt -> stmt.setObject(1, id)
        );
        return false;
    }

    @Override
    public Optional<UserDto> findByEmail(String email) {
        return jdbcAdapter.queryOne(
                "SELECT id, username, email, role FROM users WHERE email = ?",
                stmt -> stmt.setString(1, email),
                rs -> mapUserDto(rs)
        );
    }

    @Override
    public Optional<User> findFullUserByEmail(String email) {
        return jdbcAdapter.queryOne(
                "SELECT id, username, email, password_hash, role FROM users WHERE email = ?",
                stmt -> stmt.setString(1, email),
                rs -> mapUser(rs)
        );
    }

    @Override
    public Optional<UserDto> findByUsername(String username) {
        return jdbcAdapter.queryOne(
                "SELECT id, username, email, role FROM users WHERE username = ?",
                stmt -> stmt.setString(1, username),
                rs -> mapUserDto(rs)
        );
    }

    @Override
    public boolean updateUsername(UUID id, String newUsername) {
        return jdbcAdapter.update(
                "UPDATE users SET username = ? WHERE id = ?",
                stmt -> {
                    stmt.setString(1, newUsername);
                    stmt.setObject(2, id);
                }
        ) > 0;
    }

    @Override
    public boolean updateRole(UUID id, UserRole newRole) {
        return jdbcAdapter.update(
                "UPDATE users SET role = ? WHERE id = ?",
                stmt -> {
                    stmt.setString(1, newRole.name());
                    stmt.setObject(2, id);
                }
        ) > 0;
    }

//    @Override
//    public boolean deleteById(UUID id) {
//        return jdbcAdapter.update(
//                "DELETE FROM users WHERE id = ?",
//                stmt -> stmt.setObject(1, id)
//        ) > 0;
//    }

    @Override
    public Optional<UserDetailsDto> getUserDetails(UUID id) {
        return jdbcAdapter.queryOne(
                "SELECT * FROM user_details WHERE user_id = ?",
                stmt -> stmt.setObject(1, id),
                rs -> new UserDetailsDto(rs.getString("first_name"), rs.getString("last_name"), rs.getString("city"))
        );
    }

    @Override
    public void updateUserDetails(UUID id, UserDetailsDto dto) {
        jdbcAdapter.update(
                "INSERT INTO user_details (user_id, first_name, last_name, city) " +
                        "VALUES (?, ?, ?, ?) " +
                        "ON CONFLICT (user_id) DO UPDATE SET " +
                        "first_name = EXCLUDED.first_name, " +
                        "last_name = EXCLUDED.last_name, " +
                        "city = EXCLUDED.city",
                stmt -> {
                    stmt.setObject(1, id);
                    stmt.setString(2, dto.firstName());
                    stmt.setString(3, dto.lastName());
                    stmt.setString(4, dto.city());
                }
        );
    }
}
