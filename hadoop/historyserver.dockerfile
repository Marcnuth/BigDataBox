FROM bde2020/hadoop-historyserver:2.0.0-hadoop3.2.1-java8

ADD core-site.xml //opt/hadoop-3.2.1/etc/hadoop/core-site.xml

ENTRYPOINT ["/run.sh"]