// Code generation for the admin web client from the API contract (../../../backend/openapi.yaml → ../../src/app/api).
// Same openapi-generator (7.25.0) as the backend and the mobile. Run: npm run api
// Unneeded files are listed in src/app/api/.openapi-generator-ignore (kept between runs).
plugins {
    id("org.openapi.generator") version "7.25.0"
}

val apiSpec = file("../../../backend/openapi.yaml")
val apiOut = file("../../src/app/api")

openApiGenerate {
    generatorName.set("typescript-angular")
    inputSpec.set(apiSpec.absolutePath)
    outputDir.set(apiOut.absolutePath)
    configOptions.set(mapOf(
        "ngVersion" to "20.0.0",
        "providedIn" to "root",
        "stringEnums" to "true",
        "fileNaming" to "kebab-case",
        "supportsES6" to "true",
    ))
    additionalProperties.set(mapOf("hideGenerationTimestamp" to "true"))
    globalProperties.set(mapOf("apiTests" to "false", "modelTests" to "false", "apiDocs" to "false", "modelDocs" to "false"))
}

// Generated output only: drop the previous run's files (except the ignore list) so removed operations/models do not linger.
tasks.named("openApiGenerate") {
    doFirst { delete(fileTree(apiOut) { exclude(".openapi-generator-ignore") }) }
}
