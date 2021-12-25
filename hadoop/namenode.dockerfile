FROM bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8

#RUN apt install -y zip unzip hostname patch

# Install Maven
ADD http://xenia.sote.hu/ftp/mirrors/www.apache.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz /root/
RUN cd /root && tar xfv apache-maven-3.5.4-bin.tar.gz 
ENV PATH /root/apache-maven-3.5.4/bin:$PATH

# Download Oozie sources
ADD https://github.com/apache/oozie/archive/release-5.2.1.tar.gz /root/
RUN cd /root && tar xfv release-5.2.1.tar.gz 
RUN cd /root/oozie-release-5.2.1 && ./bin/mkdistro.sh  -DskipTests

# hadoop
ADD core-site.xml /opt/hadoop-3.2.1/etc/hadoop/core-site.xml
ADD namenode.run.sh /namenode.run.sh
RUN chmod a+x /namenode.run.sh

# Install Oozie
RUN mv /root/oozie-release-5.2.1/distro/target/oozie-5.2.1-distro.tar.gz /opt && cd /opt && tar xfv oozie-5.2.1-distro.tar.gz
RUN mkdir /opt/oozie-5.2.1/libext
ADD http://archive.cloudera.com/gplextras/misc/ext-2.2.zip /opt/oozie-5.2.1/libext/

# Patch Oozie webapp pom.xml
#ADD oozie-4.2.0-webapp-pom.xml.patch /root/oozie-release-4.2.0/webapp/
#RUN cd /root/oozie-release-5.2.1/webapp && patch pom.xml oozie-4.2.0-webapp-pom.xml.patch
#RUN sed -i s/http:/https:/g /root/oozie-release-4.2.0/pom.xml
#RUN sed -i 's?https://repository.codehaus.org/?https://repository-master.mulesoft.org/nexus/content/groups/public/?' /root/oozie-release-4.2.0/pom.xml
#RUN cd /root/oozie-release-5.2.1/ && mvn clean package assembly:single -DskipTests -P hadoop-3,uber -Dhadoop.version=3.2.1
#RUN mv /root/oozie-release-5.2.1/distro/target/oozie-5.2.1-distro.tar.gz /opt/ && cd /opt && tar xfv oozie-5.2.1-distro.tar.gz


ENTRYPOINT ["/namenode.run.sh"]