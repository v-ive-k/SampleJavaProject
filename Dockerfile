# 1. Use an official Maven image to build the application
FROM maven:3.9.4-openjdk-17 AS build

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy the pom.xml and the source code into the container
COPY pom.xml .
COPY src ./src

# 4. Build the application using Maven
RUN mvn clean package -DskipTests

# 5. Use a lightweight OpenJDK runtime for the final image
FROM openjdk:17-alpine

# 6. Set the working directory inside the container
WORKDIR /app

# 7. Copy the JAR file from the build stage
COPY --from=build /app/target/myproject-0.0.1-SNAPSHOT.jar ./myproject.jar

# 8. Run the Spring Boot application
CMD ["java", "-jar", "myproject.jar"]
