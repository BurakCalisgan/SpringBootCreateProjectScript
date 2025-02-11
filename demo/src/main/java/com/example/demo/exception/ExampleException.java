package com.example.demo.exception;

public class ExampleException extends Exception {
    public ExampleException(String message) {
        super(message);
    }

    public ExampleException(String message, Throwable cause) {
        super(message, cause);
    }
}
