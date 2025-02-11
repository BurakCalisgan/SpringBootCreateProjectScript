package com.example.demo.service.business;

import com.example.demo.client.model.response.UserResponse;
import com.example.demo.model.dto.request.CreateExampleRequestDto;
import com.example.demo.model.dto.response.ExampleInfoResponseDto;

import java.util.List;
import java.util.UUID;

public interface ExampleBusinessService {
    void create(CreateExampleRequestDto createExampleRequestDto) ;
    List<ExampleInfoResponseDto> getAllExampleInfo() ;
    ExampleInfoResponseDto getExampleInfo(UUID exampleId) ;
    List<UserResponse> getExampleUsersForFeignClient();
}
