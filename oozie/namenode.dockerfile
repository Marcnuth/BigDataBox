FROM andlaz/hadoop-hdfs-namenode:latest



RUN yum install -y zip unzip hostname patch

# Install Maven
ADD http://xenia.sote.hu/ftp/mirrors/www.apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz /root/
RUN cd /root && tar xfv apache-maven-3.3.9-bin.tar.gz 
ENV PATH /root/apache-maven-3.3.9/bin:$PATH

# Download Oozie sources
ADD https://github.com/apache/oozie/archive/release-4.2.0.tar.gz /root/
RUN cd /root && tar xfv release-4.2.0.tar.gz 

# Patch Oozie webapp pom.xml
ADD oozie-4.2.0-webapp-pom.xml.patch /root/oozie-release-4.2.0/webapp/
RUN cd /root/oozie-release-4.2.0/webapp && patch pom.xml oozie-4.2.0-webapp-pom.xml.patch
RUN sed -i s/http:/https:/g /root/oozie-release-4.2.0/pom.xml
RUN sed -i 's?https://repository.codehaus.org/?https://repository-master.mulesoft.org/nexus/content/groups/public/?' /root/oozie-release-4.2.0/pom.xml
RUN cd /root/oozie-release-4.2.0/ && mvn clean package assembly:single -DskipTests -P hadoop-2,uber -Dhadoop.version=2.7.1
RUN mv /root/oozie-release-4.2.0/distro/target/oozie-4.2.0-distro.tar.gz /opt/ && cd /opt && tar xfv oozie-4.2.0-distro.tar.gz

RUN mkdir -p /var/log/oozie && chown -R oozie /var/log/oozie
RUN mkdir -p /var/lib/oozie/data && chown -R oozie /var/lib/oozie
RUN ln -s /var/log/oozie /opt/oozie-4.2.0/log
RUN ln -s /var/lib/oozie/data /opt/oozie-4.2.0/data

RUN mkdir /opt/oozie-4.2.0/libext
ADD http://archive.cloudera.com/gplextras/misc/ext-2.2.zip /opt/oozie-4.2.0/libext/
RUN /opt/oozie-4.2.0/bin/oozie-setup.sh prepare-war

COPY core-site.xml /templates/opt/oozie-4.2.0/conf/hadoop-conf/core-site.xml
COPY core-site.xml /opt/oozie-4.2.0/conf/hadoop-conf/core-site.xml

RUN cd /opt/oozie-4.2.0/ && tar xzvf oozie-examples.tar.gz
RUN chown -R oozie /opt/oozie-4.2.0/
RUN chmod -R 777 /var/log/

EXPOSE 11000 11001

ENTRYPOINT ["/root/entrypoint.sh"]