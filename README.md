# BigDataBox
Dockerfiles for Big Data Tools/Frameworks: Hadoop、Spark、Oozie


# Clean
```
docker rm $(docker ps --filter status=exited -q)
docker volume rm bigdatabox_hadoop_datanode bigdatabox_hadoop_historyserver bigdatabox_hadoop_namenode
```