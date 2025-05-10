FROM maven:3.9.4-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests
RUN echo "JARs in target after build:" && ls -lh /app/target

FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=builder /app/target/gameboardprojectbackend.jar /app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
