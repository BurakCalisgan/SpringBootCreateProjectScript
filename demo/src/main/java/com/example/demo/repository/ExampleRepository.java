package com.example.demo.repository;


import com.example.demo.entity.Example;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ExampleRepository extends JpaRepository<Example, UUID> {
    Optional<Example> findByFullName(String fullName);

}
