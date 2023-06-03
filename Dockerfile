FROM alpine:latest

# Install Requirements
RUN apk update \
 && apk add --no-cache vim curl unzip \
 && apk add --no-cache python3 py3-setuptools \
 && ln -sf /usr/bin/python3 /usr/bin/python \
 && apk add --no-cache py3-pip \
 && apk add --no-cache openjdk8 \
 && apk add --no-cache docker


# Install Spark
ENV SPARK_VERSION 3.4.0
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop3
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

# Install JupyterLab
RUN pip3 install pyspark

RUN apk add --no-cache bash

WORKDIR $SPARK_HOME

RUN apk add --no-cache maven
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get\
    -Dartifact=org.apache.spark:spark-hadoop-cloud_2.12:3.4.0\
    -Ddest=jars/

RUN find ~/.m2/repository -name '*.jar' -exec cp {} jars/ \; 

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
