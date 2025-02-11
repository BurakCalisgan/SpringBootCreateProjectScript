package com.example.demo.service.business.implementation;

import com.example.demo.client.JsonPlaceHolderClient;
import com.example.demo.client.model.response.UserResponse;
import com.example.demo.mapper.ExampleMapper;
import com.example.demo.model.dto.request.CreateExampleRequestDto;
import com.example.demo.model.dto.response.ExampleInfoResponseDto;
import com.example.demo.service.business.ExampleBusinessService;
import com.example.demo.service.domain.ExampleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ExampleBusinessServiceImpl implements ExampleBusinessService {

    private final ExampleService exampleService;
    private final ExampleMapper exampleMapper;
    private final JsonPlaceHolderClient jsonPlaceHolderClient;

    @Override
    public void create(CreateExampleRequestDto createExampleRequestDto) {
        exampleService.save(exampleMapper.toEntity(createExampleRequestDto));
    }

    @Override
    public List<ExampleInfoResponseDto> getAllExampleInfo() {
        return exampleMapper.toDto(exampleService.findAll());
    }

    @Override
    public ExampleInfoResponseDto getExampleInfo(UUID exampleId) {
        return exampleMapper.toDto(exampleService.findById(exampleId));
    }

    @Override
    public List<UserResponse> getExampleUsersForFeignClient() {
        return jsonPlaceHolderClient.getUsers();
    }


}
