package org.michaloleniacz.project.persistance.core;

import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.util.Logger;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcPostgresAdapter {
    public <T>Optional<T> queryOne(final String query, final SQLConsumer<? super PreparedStatement> params, SQLCollector<? super ResultSet, ? extends T> sqlCollector) {
        try (
                final Connection connection = DatabaseConnector.getConnection();
                final PreparedStatement preparedStatement = connection.prepareStatement(query);
        ) {

            params.accept(preparedStatement);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return Optional.of(sqlCollector.collect(resultSet));
            }

            return Optional.empty();
        } catch (SQLException e) {
            Logger.error("Failed to perform a JDBC query:\n" + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public <T> ArrayList<T> queryMany(final String sql, final SQLConsumer<? super PreparedStatement> paramSetter, final SQLCollector<? super ResultSet, ? extends T> sqlCollector) {
        final ArrayList<T> results = new ArrayList<>();

        try (final Connection conn = DatabaseConnector.getConnection();
             final PreparedStatement stmt = conn.prepareStatement(sql)) {

            paramSetter.accept(stmt);

            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    results.add(sqlCollector.collect(resultSet));
                }
            }
        } catch (SQLException e) {
            Logger.error("Failed to perform a JDBC query:\n" + e.getMessage());
            throw new RuntimeException(e);
        }

        return results;
    }

    public int update(final String sql, final SQLConsumer<? super PreparedStatement> params) {
        try (final Connection conn = DatabaseConnector.getConnection();
             final PreparedStatement stmt = conn.prepareStatement(sql)) {

            params.accept(stmt);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            Logger.error("Failed to perform a JDBC update:\n" + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public int updateWithConnection(Connection conn, String sql, SQLConsumer<PreparedStatement> consumer) {
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            consumer.accept(stmt);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            throw new InternalServerErrorException("SQL update failed: " + e.getMessage());
        }
    }

    public <T> T transaction(SQLFunction<Connection, T> block) {
        try (final Connection conn = DatabaseConnector.getConnection()) {
            try {
                conn.setAutoCommit(false);
                T result = block.apply(conn);
                conn.commit();
                return result;
            } catch (Exception e) {
                conn.rollback();
                throw new InternalServerErrorException("Transaction failed: " + e.getMessage());
            }
        } catch (SQLException e) {
            throw new InternalServerErrorException("DB error: " + e.getMessage());
        }
    }
}
