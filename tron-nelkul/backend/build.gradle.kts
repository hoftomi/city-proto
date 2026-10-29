plugins {
    java
    id("org.springframework.boot") version "4.1.1"
    id("io.spring.dependency-management") version "1.1.7"
    id("org.openapi.generator") version "7.25.0"
}

group = "com.hof"
version = "0.0.1"

java {
    toolchain { languageVersion = JavaLanguageVersion.of(25) }
}

repositories { mavenCentral() }

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-webmvc")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-security-oauth2-resource-server")
    implementation("org.springframework.boot:spring-boot-starter-flyway")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("io.micrometer:micrometer-registry-prometheus")
    // Logs to Loki (Spring profile `loki`, see logback-spring.xml); 2.0.x is built on logback 1.5 like Boot 4.1
    implementation("com.github.loki4j:loki-logback-appender:2.0.3")
    implementation("com.google.firebase:firebase-admin:9.9.0")
    implementation("org.flywaydb:flyway-database-postgresql")
    implementation("org.mapstruct:mapstruct:1.6.3")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.6.3")
    runtimeOnly("org.postgresql:postgresql")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> { useJUnitPlatform() }

// The API contract (in the repo root: api/openapi.yaml) → Spring interfaces and models.
// Controllers implement these interfaces; the mobile client generates from the same file.
val apiSpec = file("./openapi.yaml")
val generatedApi = layout.buildDirectory.dir("generated/openapi")

openApiGenerate {
    generatorName.set("spring")
    inputSpec.set(apiSpec.absolutePath)
    outputDir.set(generatedApi.get().asFile.absolutePath)
    apiPackage.set("com.hof.tronnelkul.api")
    modelPackage.set("com.hof.tronnelkul.api.model")
    configOptions.set(mapOf(
        "interfaceOnly" to "true",
        "useSpringBoot3" to "true",
        "useJakartaEe" to "true",
        "skipDefaultInterface" to "true",
        "useResponseEntity" to "false",
        "useTags" to "true",
        "openApiNullable" to "false",
        "documentationProvider" to "none",
        "annotationLibrary" to "none",
        "useBeanValidation" to "false",
        "generatedConstructorWithRequiredArgs" to "true",
        "hideGenerationTimestamp" to "true",
        "sourceFolder" to "src/main/java",
    ))
    typeMappings.set(mapOf("OffsetDateTime" to "Instant", "DateTime" to "Instant"))
    importMappings.set(mapOf("Instant" to "java.time.Instant"))
    globalProperties.set(mapOf("apis" to "", "models" to "", "supportingFiles" to "false", "apiDocs" to "false", "modelDocs" to "false", "apiTests" to "false", "modelTests" to "false"))
}

sourceSets { main { java { srcDir(generatedApi.map { it.dir("src/main/java") }) } } }
tasks.named("compileJava") { dependsOn("openApiGenerate") }
tasks.named("openApiGenerate") { inputs.file(apiSpec) }
