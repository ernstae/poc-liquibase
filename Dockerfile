FROM sequenceiq/liquibase

MAINTAINER Andrew Ernst <ernstae@github.com>

ENV mysql_connector "mysql-connector-java-5.1.45"

# grab the latest mysql connector for java
RUN mkdir -p /tmp
ADD https://dev.mysql.com/get/Downloads/Connector-J/${mysql_connector}.tar.gz /tmp
RUN tar xvfz /tmp/${mysql_connector}.tar.gz -C /tmp
RUN cp /tmp/${mysql_connector}/${mysql_connector}-bin.jar /opt/liquibase/lib

# Clean up
RUN rm -rf /tmp/${mysql_connector}
RUN mkdir -p /schema

VOLUME ["/schema"]



