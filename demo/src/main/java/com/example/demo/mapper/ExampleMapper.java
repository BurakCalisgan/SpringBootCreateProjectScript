package com.example.demo.mapper;

import com.example.demo.entity.Example;
import com.example.demo.model.dto.request.CreateExampleRequestDto;
import com.example.demo.model.dto.response.ExampleInfoResponseDto;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ExampleMapper {
    Example toEntity(CreateExampleRequestDto createExampleRequestDto);
    ExampleInfoResponseDto toDto(Example example);
    List<ExampleInfoResponseDto> toDto(List<Example> symbols);
}
