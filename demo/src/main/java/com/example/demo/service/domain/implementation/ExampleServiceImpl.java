package com.example.demo.service.domain.implementation;


import com.example.demo.entity.Example;
import com.example.demo.repository.ExampleRepository;
import com.example.demo.service.domain.ExampleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ExampleServiceImpl implements ExampleService {
    private final ExampleRepository repository;

    @Override
    public Example findByFullName(String fullName) throws Exception {
        return repository.findByFullName(fullName)
                .orElseThrow(() -> new Exception("No chat found with fullName " + fullName));
    }

    @Override
    public void save(Example example) {
        repository.save(example);
    }

    @Override
    public Example findById(UUID id) {
        return repository.findById(id).orElseThrow();
    }

    @Override
    public List<Example> findAll() {
        return repository.findAll();
    }
}
