package com.example.demo.util.props;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "feign")
public class FeignClientProperties {
    private long connectTimeout;
    private long readTimeout;
}
