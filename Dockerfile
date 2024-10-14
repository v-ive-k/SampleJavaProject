# 1. Use an official OpenJDK runtime as a parent image
FROM openjdk:17-alpine

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy HelloWorld.java from the correct path into the container at /app
COPY myproject/src/main/java/myproject/HelloWorld .

# 4. Compile the HelloWorld.java file
RUN pwd && ls -la
RUN mvn validate compile package

# 5. Run the HelloWorld class
CMD ["java", "HelloWorld"]
