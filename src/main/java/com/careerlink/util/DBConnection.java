package com.careerlink.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_HOST = System.getenv().getOrDefault("DB_HOST", "localhost");

    private static final String DB_PORT = System.getenv().getOrDefault("DB_PORT", "3306");

    private static final String DB_NAME = System.getenv().getOrDefault("DB_NAME", "careerlink");

    private static final String USER = System.getenv().getOrDefault("DB_USER", "root");

    private static final String PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "");

    private static final String URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}