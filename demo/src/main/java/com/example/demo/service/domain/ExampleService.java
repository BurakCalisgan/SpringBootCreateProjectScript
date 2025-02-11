package com.example.demo.service.domain;


import com.example.demo.entity.Example;

import java.util.List;
import java.util.UUID;

public interface ExampleService {
    Example findByFullName(String fullName) throws Exception;
    void save(Example example);
    Example findById(UUID id);
    List<Example> findAll();
}
