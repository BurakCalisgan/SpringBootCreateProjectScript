param (
    [string]$ProjectName = "my-api-project",
    [string]$GroupId = "com.example",
    [string]$ArtifactId = "my-api"
)

# Set Java version to 23
$JavaVersion = "23"

# Fetch the latest stable Spring Boot version dynamically
$SpringBootVersion = (Invoke-WebRequest -Uri "https://start.spring.io/metadata/client" -UseBasicParsing | ConvertFrom-Json).bootVersion.default

# Create the project directory and navigate to it
New-Item -ItemType Directory -Path $ProjectName -Force
Set-Location -Path $ProjectName

# Generate the Maven project
mvn archetype:generate -DgroupId=$GroupId -DartifactId=$ArtifactId -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

# Move into the project directory
Set-Location -Path $ArtifactId

# 📌 Create the required folder structure
$folders = @(
    "src/main/java/$($GroupId -replace '\.', '/')/config",
    "src/main/java/$($GroupId -replace '\.', '/')/controller",
    "src/main/java/$($GroupId -replace '\.', '/')/entity",
    "src/main/java/$($GroupId -replace '\.', '/')/exception",
    "src/main/java/$($GroupId -replace '\.', '/')/filter",
    "src/main/java/$($GroupId -replace '\.', '/')/model/dto/request",
    "src/main/java/$($GroupId -replace '\.', '/')/model/dto/response",
    "src/main/java/$($GroupId -replace '\.', '/')/model/enums",
    "src/main/java/$($GroupId -replace '\.', '/')/repository",
    "src/main/java/$($GroupId -replace '\.', '/')/service",
    "src/main/java/$($GroupId -replace '\.', '/')/util/constants",
    "src/main/java/$($GroupId -replace '\.', '/')/util/props",
    "src/main/resources",
    "src/test/java/$($GroupId -replace '\.', '/')"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force
}

# 📌 Read `pom-template.xml` and replace placeholders
$PomTemplate = Get-Content -Path "../pom-template.xml" -Raw
$PomTemplate = $PomTemplate -replace "{{GROUP_ID}}", $GroupId
$PomTemplate = $PomTemplate -replace "{{ARTIFACT_ID}}", $ArtifactId
$PomTemplate = $PomTemplate -replace "{{SPRING_BOOT_VERSION}}", $SpringBootVersion
Set-Content -Path "pom.xml" -Value $PomTemplate

# 📌 Create the main `application.yml` file
$ApplicationYml = @"
spring:
  profiles:
    active: dev
    include:
      - common
      - db
  application:
    name: $ProjectName
"@
Set-Content -Path "src/main/resources/application.yml" -Value $ApplicationYml

# 📌 Create the `application-db.yml` file for database configuration
$ApplicationDbYml = @"
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/mydatabase
    username: myuser
    password: mypassword
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
"@
Set-Content -Path "src/main/resources/application-db.yml" -Value $ApplicationDbYml

# 📌 Create the `application-common.yml` file
$ApplicationCommonYml = @"
server:
  port: 8080
"@
Set-Content -Path "src/main/resources/application-common.yml" -Value $ApplicationCommonYml

# 📌 Generate a sample Controller
$ControllerContent = @"
package $GroupId.controller;

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
"@
Set-Content -Path "src/main/java/$($GroupId -replace '\.', '/')/controller/ExampleController.java" -Value $ControllerContent

# 📌 Create the main application class
$MainClassContent = @"
package $GroupId;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
"@
Set-Content -Path "src/main/java/$($GroupId -replace '\.', '/')/Application.java" -Value $MainClassContent

# 📌 Create a test class for Spring Boot
$TestClassContent = @"
package $GroupId;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class ApplicationTests {

    @Test
    void contextLoads() {
        assertThat(true).isTrue();
    }
}
"@
Set-Content -Path "src/test/java/$($GroupId -replace '\.', '/')/ApplicationTests.java" -Value $TestClassContent

Write-Host "🚀 Project successfully created: $ProjectName"
