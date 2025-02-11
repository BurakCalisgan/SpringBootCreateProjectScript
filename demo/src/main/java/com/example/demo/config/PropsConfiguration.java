package com.example.demo.config;

import com.example.demo.util.props.FeignClientProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties({FeignClientProperties.class})
public class PropsConfiguration {
}
