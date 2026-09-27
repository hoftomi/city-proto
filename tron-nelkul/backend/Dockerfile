# A build-kontextus a repó gyökere (az API-szerződés az api/ mappában van), lásd docker-compose.yml és /.dockerignore
FROM eclipse-temurin:25-jdk AS build
WORKDIR /work
COPY api api
COPY tron-nelkul/backend tron-nelkul/backend
WORKDIR /work/tron-nelkul/backend
RUN ./gradlew --no-daemon bootJar -x test

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /work/tron-nelkul/backend/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
