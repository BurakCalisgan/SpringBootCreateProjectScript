package com.example.demo.model.dto.response;

import lombok.Data;

import java.util.UUID;

@Data
public class ExampleInfoResponseDto {

    private UUID id;
    private String email;
    private String fullName;

}
