hadoop fs -chmod -R 777 /
oozie-setup.sh sharelib create -fs hdfs://namenode:8020


chmod -R 777 /var/lib/oozie/data/oozie-db/
chown -R oozie /var/lib/oozie/data/oozie-db