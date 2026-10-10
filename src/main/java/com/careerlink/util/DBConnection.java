package com.careerlink.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_HOST =
            System.getenv("DB_HOST");

    private static final String DB_PORT =
            System.getenv().getOrDefault("DB_PORT", "23338");

    private static final String DB_NAME =
            System.getenv().getOrDefault("DB_NAME", "defaultdb");

    private static final String USER =
            System.getenv("DB_USER");

    private static final String PASSWORD =
            System.getenv("DB_PASSWORD");

    private static final String URL =
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?sslMode=REQUIRED&serverTimezone=UTC";

    public static Connection getConnection() throws SQLException {
        if (DB_HOST == null || USER == null || PASSWORD == null) {
            throw new SQLException(
                    "Database configuration environment variables are missing.");
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found.", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}