### BUILD ANGULAR ###
FROM node:20.9.0-slim AS angular

WORKDIR /app

# copy files from root directory
COPY client/angular.json .
COPY client/package-lock.json .
COPY client/package.json .
COPY client/tsconfig.app.json .
COPY client/tsconfig.json .
COPY client/tsconfig.spec.json .
# copy directories from root directory
COPY client/src ./src

# install angular
RUN npm install -g @angular/cli

# install packages and build
RUN npm i
RUN ng build


### BUILD JAVA MAVEN SPRINGBOOT WITH SOURCE CODE ###
FROM maven:3.9.0-eclipse-temurin-19 AS springboot

WORKDIR /app

# copy files from root directory
COPY server/mvnw .
COPY server/mvnw.cmd .
COPY server/pom.xml .
COPY server/src ./src

# copy compiled angular app to static directory of springboot for single origin deployment
COPY --from=angular /app/dist/client ./src/main/resources/static

RUN mvn package -Dmaven.test.skip=true


### RUN JAVA WITHOUT SOURCE CODE, USING JAR FILE ###
## this will allow the container to run only the binary file without the source code ##
## this reduces the file size significantly ##
FROM eclipse-temurin:19-jre

WORKDIR /app

# copy jar file from springboot build 
COPY --from=springboot /app/target/server-0.0.1-SNAPSHOT.jar server.jar

## run
ENV PORT=8080
ENV DB_SERVER=localhost
ENV DB_PORT=3306
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=rootroot
ENV SPRING_DATASOURCE_URL=jdbc:mysql://$(DB_SERVER):$(DB_PORT)/miniproject
ENV SPRING_DATASOURCE_DRIVER-CLASS-NAME=com.mysql.cj.jdbc.Driver
ENV SPRING_JPA_HIBERNATE_DDL-AUTO=none
ENV SPRING_JPA_SHOW-SQL=true
ENV SPRING_JPA_PROPERTIES_HIBERNATE_FORMAT_SQL=true
ENV SPRING_JPA_DATABASE-PLATFORM=org.hibernate.dialect.MySQLDialect

EXPOSE ${PORT}

ENTRYPOINT java -Dserver.port=${PORT} -jar server.jar