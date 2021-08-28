FROM ubuntu:18.04

# install core dependencies
RUN \
  apt-get update && \
  apt install -y curl git unzip maven openjdk-11-jre-headless

WORKDIR /app

# kafka dist needed for Kafka Connect
RUN \
  curl -O https://archive.apache.org/dist/kafka/2.8.0/kafka_2.13-2.8.0.tgz && \
  tar xfz kafka_2.13-2.8.0.tgz && \
  rm kafka_2.13-2.8.0.tgz

# get gradle, used to build weather connector
RUN \
  curl https://downloads.gradle-dn.com/distributions/gradle-4.10.3-bin.zip -o /tmp/gradle.zip && \
  mkdir /tmp/gradlebin && \
  cd /tmp/gradlebin && \
  unzip /tmp/gradle.zip

# download dependencies
RUN \
  mkdir /app/jars && \
  cd /app/jars && \
  curl -O http://archive.apache.org/dist/avro/avro-1.9.2/java/avro-1.9.2.jar && \
  curl -O http://archive.apache.org/dist/avro/avro-1.9.2/java/avro-tools-1.9.2.jar && \
  curl -O https://repo1.maven.org/maven2/org/apache/commons/commons-compress/1.19/commons-compress-1.19.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/guava/guava/29.0-jre/guava-29.0-jre.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar && \
  curl -O https://repo1.maven.org/maven2/dk/brics/automaton/automaton/1.11-8/automaton-1.11-8.jar && \
  curl -O https://repo1.maven.org/maven2/org/glassfish/hk2/osgi-resource-locator/1.0.3/osgi-resource-locator-1.0.3.jar && \
  curl -O https://repo1.maven.org/maven2/org/glassfish/jersey/core/jersey-common/2.30/jersey-common-2.30.jar && \
  curl -O https://repo1.maven.org/maven2/io/swagger/swagger-annotations/1.6.2/swagger-annotations-1.6.2.jar && \
  curl -O https://repo1.maven.org/maven2/org/checkerframework/checker-qual/2.11.1/checker-qual-2.11.1.jar && \
  curl -O https://repo1.maven.org/maven2/io/confluent/confluent-log4j/1.2.17-cp2/confluent-log4j-1.2.17-cp2.jar && \
  curl -O https://repo1.maven.org/maven2/com/github/mifmif/generex/1.0.2/generex-1.0.2.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.3.4/error_prone_annotations-2.3.4.jar && \
  curl -O https://packages.confluent.io/maven/io/confluent/common-utils/6.0.0/common-utils-6.0.0.jar && \
  curl -O https://packages.confluent.io/maven/io/confluent/kafka-avro-serializer/6.0.0/kafka-avro-serializer-6.0.0.jar && \
  curl -O https://packages.confluent.io/maven/io/confluent/kafka-schema-serializer/6.0.0/kafka-schema-serializer-6.0.0.jar && \
  curl -O https://packages.confluent.io/maven/io/confluent/kafka-connect-avro-data/6.0.0/kafka-connect-avro-data-6.0.0.jar && \
  curl -O https://packages.confluent.io/maven/io/confluent/kafka-schema-registry-client/6.0.0/kafka-schema-registry-client-6.0.0.jar
COPY third-party-dependencies/* jars/

# get the weather connector source and build it
#  (then clean up, deleting the source)
RUN \
  git clone --depth 1 https://github.com/dalelane/kafka-connect-weather-source.git && \
  cd kafka-connect-weather-source && \
  /tmp/gradlebin/gradle-4.10.3/bin/gradle build && \
  mv build/libs/kafka-connect-weather-source-1.0.jar /app/jars/. && \
  cd /app && \
  rm -rf kafka-connect-weather-source

# get the stock prices connector source and build it
#  (then clean up, deleting the source)
RUN \
  git clone --depth 1 https://github.com/dalelane/kafka-connect-stockprice-source.git && \
  cd kafka-connect-stockprice-source && \
  mvn clean package && \
  mv target/kafka-connect-stockprice-source-0.0.2-jar-with-dependencies.jar /app/jars/. && \
  cd /app && \
  rm -rf kafka-connect-stockprice-source

# remove remaining build dependencies
RUN \
  apt remove -y curl git unzip maven && \
  rm -rf /tmp/gradle.zip /tmp/gradlebin

# create folder for truststore needed for the Kafka cluster being connected to
RUN mkdir cas

# Kafka Connect config for the Kafka cluster being connected to
COPY connect-configs connect-configs

# config for the Kafka Connect connectors being run
COPY connector-configs connector-configs
COPY flightlandings.avsc .

# start command
COPY run.sh .
CMD [ "./run.sh" ]
