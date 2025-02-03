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

# Convert project name to PascalCase for class naming (my-awesome-api -> MyAwesomeApi)
function ConvertToPascalCase($name) {
    $parts = $name -split '[-_]'
    return ($parts | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
}

$ApplicationClassName = "$(ConvertToPascalCase $ArtifactId)Application"
$TestClassName = "$(ConvertToPascalCase $ArtifactId)ApplicationTests"
$ApplicationName = ConvertToPascalCase $ProjectName  # Convert ProjectName to PascalCase

# Remove dashes from paths (my-awesome-api -> myawesomeapi)
$ArtifactId = $ArtifactId -replace '[-_]', ''

# Set Java version to 23
$JavaVersion = "23"

# Fetch the latest stable Spring Boot version dynamically
$SpringBootVersion = (Invoke-WebRequest -Uri "https://start.spring.io/metadata/client" -UseBasicParsing | ConvertFrom-Json).bootVersion.default

# Create the project directory
New-Item -ItemType Directory -Path $ProjectName -Force
Set-Location -Path $ProjectName

# Generate the Maven project
mvn archetype:generate -DgroupId=$GroupId -DartifactId=$ArtifactId -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

# Check if the expected directory exists
$GeneratedProjectPath = "$ProjectName/$ArtifactId"
if (Test-Path $GeneratedProjectPath) {
    Set-Location -Path $GeneratedProjectPath
} else {
    Write-Host "❌ The expected project directory '$GeneratedProjectPath' was not found!" -ForegroundColor Red
    exit
}

# 📌 Determine the correct package path
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
$PomTemplate = Get-Content -Path "../templates/pom-template.xml" -Raw
$PomTemplate = $PomTemplate -replace "{{GROUP_ID}}", $GroupId
$PomTemplate = $PomTemplate -replace "{{ARTIFACT_ID}}", $ArtifactId
$PomTemplate = $PomTemplate -replace "{{SPRING_BOOT_VERSION}}", $SpringBootVersion
Set-Content -Path "pom.xml" -Value $PomTemplate

# 📌 Read and update `application.yml` from templates/yml/
$ApplicationYaml = Get-Content -Path "../templates/yml/application.yml" -Raw
$ApplicationYaml = $ApplicationYaml -replace "{{APPLICATION_NAME}}", $ApplicationName
Set-Content -Path "src/main/resources/application.yml" -Value $ApplicationYaml

# 📌 Read and copy `application-db.yml` & `application-common.yml`
$YamlFiles = @("application-db.yml", "application-common.yml")

foreach ($file in $YamlFiles) {
    $content = Get-Content -Path "../templates/yml/$file" -Raw
    Set-Content -Path "src/main/resources/$file" -Value $content
}

# 📌 Read Controller template and replace placeholders
$ControllerTemplate = Get-Content -Path "../templates/ExampleController.java" -Raw
$ControllerTemplate = $ControllerTemplate -replace "{{GROUP_ID}}", $GroupId
$ControllerTemplate = $ControllerTemplate -replace "{{ARTIFACT_ID}}", $ArtifactId
Set-Content -Path "$PackagePath/controller/ExampleController.java" -Value $ControllerTemplate

# 📌 Read Application template and replace placeholders
$ApplicationTemplate = Get-Content -Path "../templates/Application.java" -Raw
$ApplicationTemplate = $ApplicationTemplate -replace "{{GROUP_ID}}", $GroupId
$ApplicationTemplate = $ApplicationTemplate -replace "{{APPLICATION_CLASS}}", $ApplicationClassName
Set-Content -Path "$PackagePath/$ApplicationClassName.java" -Value $ApplicationTemplate

# 📌 Read Test template and replace placeholders
$TestTemplate = Get-Content -Path "../templates/ApplicationTests.java" -Raw
$TestTemplate = $TestTemplate -replace "{{GROUP_ID}}", $GroupId
$TestTemplate = $TestTemplate -replace "{{APPLICATION_TEST_CLASS}}", $TestClassName
Set-Content -Path "$TestPackagePath/$TestClassName.java" -Value $TestTemplate

Write-Host "🚀 Project successfully created: $ProjectName"
