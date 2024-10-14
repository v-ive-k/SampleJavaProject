# 1. Use an official OpenJDK runtime as a parent image
FROM openjdk:17-alpine

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy the current directory contents (including HelloWorld.java) into the container at /app
COPY . .

# 4. Compile the HelloWorld.java file
RUN javac HelloWorld.java

# 5. Run the HelloWorld class
CMD ["java", "HelloWorld"]
