# syntax=docker/dockerfile:1

FROM eclipse-temurin:11-jre-alpine

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} registration-service.jar
ENTRYPOINT ["java","-jar","/registration-service.jar"]
