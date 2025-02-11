package com.example.demo.controller;

import com.example.demo.client.model.response.UserResponse;
import com.example.demo.model.dto.request.CreateExampleRequestDto;
import com.example.demo.model.dto.response.ExampleInfoResponseDto;
import com.example.demo.service.business.ExampleBusinessService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/example")
@RequiredArgsConstructor
@Slf4j
public class ExampleController {
    private final ExampleBusinessService exampleBusinessService;

    @GetMapping("/all-example")
    public ResponseEntity<List<ExampleInfoResponseDto>> getAllExample() {
        return new ResponseEntity<>(exampleBusinessService.getAllExampleInfo(), HttpStatus.OK);
    }

    @GetMapping("/get-example-by-id/{id}")
    public ResponseEntity<ExampleInfoResponseDto> getExampleById(@PathVariable UUID id) {
        return new ResponseEntity<>(exampleBusinessService.getExampleInfo(id), HttpStatus.OK);
    }

    @PostMapping("/create")
    private void createExample(@RequestBody CreateExampleRequestDto createExampleRequestDto) {
        exampleBusinessService.create(createExampleRequestDto);
    }

    @GetMapping("/feign-example-users")
    public ResponseEntity<List<UserResponse>> getExampleUsers() {
        return new ResponseEntity<>(exampleBusinessService.getExampleUsersForFeignClient(), HttpStatus.OK);
    }
}

