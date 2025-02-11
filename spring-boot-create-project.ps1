param (
    [string]$ProjectName = "my-awesome-api",
    [string]$GroupId = "com.example",
    [string]$ArtifactId = "my-awesome-api"
)

# Check if Maven is installed
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Maven is not installed or not found in PATH. Please install Maven and try again." -ForegroundColor Red
    exit
}

# Convert project name to PascalCase for class naming (my-awesome-api -> MyAwesomeApi)
function ConvertToPascalCase($name) {
    return ($name -split '[-_]' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() }) -join ''
}

$ApplicationClassName = "$(ConvertToPascalCase $ArtifactId)Application"
$TestClassName = "$(ConvertToPascalCase $ArtifactId)ApplicationTests"
$ApplicationName = ConvertToPascalCase $ProjectName  # Convert ProjectName to PascalCase

# Normalize ArtifactId (remove dashes and underscores)
$NormalizedArtifactId = $ArtifactId -replace '[-_]', ''

# Set Java version to 23
$JavaVersion = "23"

# Fetch the latest stable Spring Boot version dynamically
$SpringBootVersion = (Invoke-WebRequest -Uri "https://start.spring.io/metadata/client" -UseBasicParsing | ConvertFrom-Json).bootVersion.default

# Remove existing project folder if it exists
if (Test-Path $ProjectName) {
    Remove-Item -Recurse -Force $ProjectName
}

# Generate the Maven project in the correct location
$mavenOutput = mvn archetype:generate `
    -DgroupId="$($GroupId)" `
    -DartifactId="$($NormalizedArtifactId)" `
    -Dpackage="$($GroupId)" `
    -DarchetypeArtifactId=maven-archetype-quickstart `
    -DinteractiveMode=false 2>&1

# Check if Maven project was created successfully
if ($mavenOutput -match "BUILD FAILURE" -or -not (Test-Path "$NormalizedArtifactId/pom.xml")) {
    Write-Host "❌ Maven project generation failed. Check the output for details." -ForegroundColor Red
    Write-Host $mavenOutput
    exit
}

# Rename the created directory to ProjectName
Rename-Item -Path "$NormalizedArtifactId" -NewName "$ProjectName"

# Move into the ProjectName directory
Set-Location -Path $ProjectName

# 📌 **GEREKSİZ `App.java` ve `AppTest.java` DOSYALARINI SİL**
Remove-Item -Force "src/main/java/$($GroupId -replace '\.', '/')/App.java" -ErrorAction SilentlyContinue
Remove-Item -Force "src/test/java/$($GroupId -replace '\.', '/')/AppTest.java" -ErrorAction SilentlyContinue

# 📌 Determine the correct package path
$PackagePath = "src/main/java/$($GroupId -replace '\.', '/')/$NormalizedArtifactId"
$TestPackagePath = "src/test/java/$($GroupId -replace '\.', '/')/$NormalizedArtifactId"

# 📌 Create the required folder structure
$folders = @(
    "$PackagePath/client/model/request",
    "$PackagePath/client/model/response",
    "$PackagePath/config",
    "$PackagePath/controller",
    "$PackagePath/entity",
    "$PackagePath/exception",
    "$PackagePath/filter",
    "$PackagePath/mapper",
    "$PackagePath/model/dto/request",
    "$PackagePath/model/dto/response",
    "$PackagePath/model/enums",
    "$PackagePath/repository",
    "$PackagePath/service/business",
    "$PackagePath/service/domain",
    "$PackagePath/service/external",
    "$PackagePath/util/constants",
    "$PackagePath/util/props",
    "src/main/resources",
    "$TestPackagePath"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force
}

# Copy Git-related files from templates/git
$GitTemplateDir = "../templates/git"
$GitFiles = @(".gitignore", ".gitattributes")

foreach ($file in $GitFiles) {
    if (Test-Path "$GitTemplateDir/$file") {
        Copy-Item -Path "$GitTemplateDir/$file" -Destination "." -Force
    }
}

# Copy Maven-related files from templates/maven
$MavenTemplateDir = "../templates/maven"
$MavenFiles = @("mvnw", "mvnw.cmd")

foreach ($file in $MavenFiles) {
    if (Test-Path "$MavenTemplateDir/$file") {
        Copy-Item -Path "$MavenTemplateDir/$file" -Destination "." -Force
    }
}

# Copy .mvn folder from templates/maven
$MvnFolder = "$MavenTemplateDir/.mvn"
if (Test-Path $MvnFolder) {
    Copy-Item -Path "$MvnFolder" -Destination "." -Recurse -Force
}

# 📌 Read `pom-template.xml` and replace placeholders
$PomTemplate = Get-Content -Path "../templates/pom-template.xml" -Raw
$PomTemplate = $PomTemplate -replace "{{GROUP_ID}}", $GroupId
$PomTemplate = $PomTemplate -replace "{{ARTIFACT_ID_WITH_DASH}}", $ArtifactId
$PomTemplate = $PomTemplate -replace "{{ARTIFACT_ID}}", $NormalizedArtifactId
$PomTemplate = $PomTemplate -replace "{{SPRING_BOOT_VERSION}}", $SpringBootVersion
$PomTemplate = $PomTemplate -replace "{{JAVA_VERSION}}", $JavaVersion
Set-Content -Path "pom.xml" -Value $PomTemplate

# 📌 Read and update `application.yml` from templates/yml/
$ApplicationYaml = Get-Content -Path "../templates/yml/application.yml" -Raw
$ApplicationYaml = $ApplicationYaml -replace "{{APPLICATION_NAME}}", $ApplicationName
Set-Content -Path "src/main/resources/application.yml" -Value $ApplicationYaml

# 📌 Read and copy `application-db.yml` & `application-common.yml`
$YamlFiles = @("application-db.yml", "application-common.yml", "application-feign.yml", "application-logging.yml")

foreach ($file in $YamlFiles) {
    $content = Get-Content -Path "../templates/yml/$file" -Raw
    Set-Content -Path "src/main/resources/$file" -Value $content
}

# 📌 Read Controller template and replace placeholders
$ControllerTemplate = Get-Content -Path "../templates/classes/ExampleController.java" -Raw
$ControllerTemplate = $ControllerTemplate -replace "{{GROUP_ID}}", $GroupId
$ControllerTemplate = $ControllerTemplate -replace "{{ARTIFACT_ID}}", $NormalizedArtifactId
Set-Content -Path "$PackagePath/controller/ExampleController.java" -Value $ControllerTemplate

# 📌 Read Application template and replace placeholders
$ApplicationTemplate = Get-Content -Path "../templates/classes/Application.java" -Raw
$ApplicationTemplate = $ApplicationTemplate -replace "{{GROUP_ID}}", $GroupId
$ApplicationTemplate = $ApplicationTemplate -replace "{{ARTIFACT_ID}}", $NormalizedArtifactId
$ApplicationTemplate = $ApplicationTemplate -replace "{{APPLICATION_CLASS}}", $ApplicationClassName
Set-Content -Path "$PackagePath/$ApplicationClassName.java" -Value $ApplicationTemplate

# 📌 Read Test template and replace placeholders
$TestTemplate = Get-Content -Path "../templates/classes/ApplicationTests.java" -Raw
$TestTemplate = $TestTemplate -replace "{{GROUP_ID}}", $GroupId
$TestTemplate = $TestTemplate -replace "{{ARTIFACT_ID}}", $NormalizedArtifactId
$TestTemplate = $TestTemplate -replace "{{APPLICATION_TEST_CLASS}}", $TestClassName
Set-Content -Path "$TestPackagePath/$TestClassName.java" -Value $TestTemplate

Write-Host "🚀 Project successfully created: $ProjectName"
