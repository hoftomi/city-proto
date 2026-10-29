# The build context is the repo root (see docker-compose.yml and /.dockerignore); the API contract is backend/openapi.yaml
FROM eclipse-temurin:25-jdk AS build
WORKDIR /work
COPY tron-nelkul/backend tron-nelkul/backend
WORKDIR /work/tron-nelkul/backend
RUN ./gradlew --no-daemon bootJar -x test

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /work/tron-nelkul/backend/build/libs/*.jar app.jar
# 8080: API, 8091: actuator (health, Prometheus metrics), keep it internal
EXPOSE 8080 8091
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
