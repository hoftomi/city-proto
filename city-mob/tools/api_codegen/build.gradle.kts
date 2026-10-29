// Code generation for the mobile client from the API contract (../../../tron-nelkul/backend/openapi.yaml → ../../packages/tron_api).
// Same openapi-generator (7.25.0) as the backend. Run: tools/generate_api.sh
plugins {
    id("org.openapi.generator") version "7.25.0"
}

val apiSpec = file("../../../tron-nelkul/backend/openapi.yaml")

openApiGenerate {
    generatorName.set("dart-dio")
    inputSpec.set(apiSpec.absolutePath)
    outputDir.set(file("../../packages/tron_api").absolutePath)
    configOptions.set(mapOf(
        "pubName" to "tron_api",
        "serializationLibrary" to "json_serializable",
        "dateLibrary" to "core",
    ))
    additionalProperties.set(mapOf("hideGenerationTimestamp" to "true"))
    globalProperties.set(mapOf("apiTests" to "false", "modelTests" to "false", "apiDocs" to "false", "modelDocs" to "false"))
}
