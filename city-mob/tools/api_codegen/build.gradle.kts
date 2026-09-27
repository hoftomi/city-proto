// A mobil kliens kódgenerálása az API-szerződésből (../../../api/openapi.yaml → ../../packages/tron_api).
// Ugyanaz az openapi-generator (7.25.0), mint a backendben. Futtatás: tools/generate_api.sh
plugins {
    id("org.openapi.generator") version "7.25.0"
}

val apiSpec = file("../../../api/openapi.yaml")

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
