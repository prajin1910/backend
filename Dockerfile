# Use an official OpenJDK image
FROM eclipse-temurin:17-jdk-alpine as builder

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies
# Download dependencies
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline


# Copy source code
COPY src src

# Build application
RUN ./mvnw package -DskipTests

# ========================
# Runtime image
# ========================
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy jar file from builder
COPY --from=builder /app/target/*.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java","-jar","app.jar"]
