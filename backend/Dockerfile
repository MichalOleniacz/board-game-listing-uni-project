FROM maven:3.9.4-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests
RUN echo "JARs in target after build:" && ls -lh /app/target

FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=builder /app/target/gameboardprojectbackend.jar /app/app.jar
EXPOSE 8080
EXPOSE 5005

ENTRYPOINT ["sh", "-c", "\
  if [ \"$DEBUG\" = 1 ]; then \
    echo 'Starting in DEBUG mode on port 5005'; \
    exec java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar app.jar; \
  else \
    echo 'Starting in NORMAL mode'; \
    exec java -jar app.jar; \
  fi"]
