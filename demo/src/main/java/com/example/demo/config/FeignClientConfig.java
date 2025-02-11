package com.example.demo.config;

import com.example.demo.util.props.FeignClientProperties;
import feign.Logger;
import feign.Request;
import lombok.RequiredArgsConstructor;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
@EnableFeignClients(basePackages = "com.example.demo")
@RequiredArgsConstructor
public class FeignClientConfig {

    private final FeignClientProperties feignClientProperties;

    @Bean
    public Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }

    @Bean
    public Request.Options feignRequestOptions() {
        return new Request.Options(
                feignClientProperties.getConnectTimeout(), TimeUnit.MILLISECONDS,
                feignClientProperties.getReadTimeout(), TimeUnit.MILLISECONDS,
                true
        );
    }
}
