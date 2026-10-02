package com.careerlink.util;

import java.sql.Connection;

public class TestConnection {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {

            System.out.println("Database connected successfully!");

        } catch (Exception e) {

            e.printStackTrace();

        }
    }
}