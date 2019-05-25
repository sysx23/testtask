FROM maven:3-jdk-8 as builder
WORKDIR /root/
RUN git clone https://github.com/djessup/java-webserver
WORKDIR java-webserver
RUN mvn clean package


FROM openjdk:8
COPY --from=builder root/java-webserver/target/java-webserver-1.0.0.jar /opt/
EXPOSE 80
RUN mkdir -p /srv/www
CMD ["java", "-jar", "/opt/java-webserver-1.0.0.jar", "--port", "80","--docroot", "/srv/www"]
