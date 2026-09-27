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
    implementation("com.google.firebase:firebase-admin:9.9.0")
    implementation("org.flywaydb:flyway-database-postgresql")
    runtimeOnly("org.postgresql:postgresql")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> { useJUnitPlatform() }

// Az API-szerződés (a repó gyökerében: api/openapi.yaml) → Spring-interfészek és modellek.
// A vezérlők ezeket az interfészeket valósítják meg; a mobil kliens ugyanebből a fájlból generál.
val apiSpec = file("../../api/openapi.yaml")
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
