FROM maven:3.8.6-openjdk-11

ENV DB_URL=localhost
ENV DB_NAME=goldendb
ENV DB_USERNAME=admin
ENV DB_PASSWORD=DevOps2022
ENV DB_PORT=3306

WORKDIR /app

ADD pom.xml .

RUN ["/usr/local/bin/mvn-entrypoint.sh","mvn","verify","clean","--fail-never"]

COPY src src/

RUN mvn package -DskipTests

EXPOSE 8080

ENTRYPOINT ["java","-jar","target/javabelt-0.0.1-SNAPSHOT.war"]