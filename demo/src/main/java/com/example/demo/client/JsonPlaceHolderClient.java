package com.example.demo.client;

import com.example.demo.client.model.request.UserRequest;
import com.example.demo.client.model.response.UserResponse;
import com.example.demo.config.FeignClientConfig;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@FeignClient(
        name = "json-placeholder-client",
        url = "${feign.client.json-place-holder.url}",
        configuration = FeignClientConfig.class
)
public interface JsonPlaceHolderClient {
    @GetMapping("/users")
    List<UserResponse> getUsers();

    @PostMapping("/users")
    UserResponse createUser(@RequestBody UserRequest userRequest);
}
