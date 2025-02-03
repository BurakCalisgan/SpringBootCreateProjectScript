package {{GROUP_ID}}.{{ARTIFACT_ID}}.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/example")
public class ExampleController {

    @GetMapping
    public String helloWorld() {
        return "Hello, Spring Boot!";
    }
}
