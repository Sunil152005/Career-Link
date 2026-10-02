# ==========================================
# Stage 1: Build CareerLink using Maven
# ==========================================

FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn clean package -DskipTests


# ==========================================
# Stage 2: Run CareerLink using Tomcat
# ==========================================

FROM tomcat:10.1.57-jdk17-temurin

# Remove Tomcat default applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy CareerLink WAR into Tomcat
COPY --from=build /app/target/CareerLink.war /usr/local/tomcat/webapps/ROOT.war

# Render provides the PORT environment variable.
# Locally, if PORT is not set, Tomcat uses 8080.
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]