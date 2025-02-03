param (
    [string]$ProjectName = "my-api-project",
    [string]$GroupId = "com.example",
    [string]$ArtifactId = "my-api"
)

# Check if Maven is installed
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Maven is not installed or not found in PATH. Please install Maven and try again." -ForegroundColor Red
    exit
}

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

# 📌 Determine the package path
$PackagePath = "src/main/java/$($GroupId -replace '\.', '/')/$ArtifactId"
$TestPackagePath = "src/test/java/$($GroupId -replace '\.', '/')/$ArtifactId"

# 📌 Create the required folder structure
$folders = @(
    "$PackagePath/config",
    "$PackagePath/controller",
    "$PackagePath/entity",
    "$PackagePath/exception",
    "$PackagePath/filter",
    "$PackagePath/model/dto/request",
    "$PackagePath/model/dto/response",
    "$PackagePath/model/enums",
    "$PackagePath/repository",
    "$PackagePath/service",
    "$PackagePath/util/constants",
    "$PackagePath/util/props",
    "src/main/resources",
    "$TestPackagePath"
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

# 📌 Create `application.yml`
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

# 📌 Create `application-db.yml`
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

# 📌 Create `application-common.yml`
$ApplicationCommonYml = @"
server:
  port: 8080
"@
Set-Content -Path "src/main/resources/application-common.yml" -Value $ApplicationCommonYml

# 📌 Generate a sample Controller
$ControllerContent = @"
package $GroupId.$ArtifactId.controller;

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
Set-Content -Path "$PackagePath/controller/ExampleController.java" -Value $ControllerContent

# 📌 Create the main application class
$MainClassContent = @"
package $GroupId.$ArtifactId;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
"@
Set-Content -Path "$PackagePath/Application.java" -Value $MainClassContent

# 📌 Create a test class for Spring Boot
$TestClassContent = @"
package $GroupId.$ArtifactId;

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
Set-Content -Path "$TestPackagePath/ApplicationTests.java" -Value $TestClassContent

Write-Host "🚀 Project successfully created: $ProjectName"
