
#!/bin/sh

# prerequisites
# jdk  1.7 or higher 
# git
# npm
# maven 
# curl
# wget

export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
DEMO_HOME=`pwd`

### CASSANDRA 2.1.7 #################################################

CASSANDRA_DOWNLOAD_VERSION='cassandra/2.1.7/apache-cassandra-2.1.7-bin.tar.gz'
CASSANDRA_DOWNLOAD_MIRROR=`curl -s "http://www.apache.org/dyn/closer.cgi?path=/${CASSANDRA_DOWNLOAD_VERSION}&as_json=1" | \
                             python -c 'import json,sys;obj=json.load(sys.stdin);print obj["http"][1]' `

wget $CASSANDRA_DOWNLOAD_MIRROR$CASSANDRA_DOWNLOAD_VERSION
tar -zxf apache-cassandra-2.1.7-bin.tar.gz

CASSANDRA_HOME=$DEMO_HOME/apache-cassandra-2.1.7

### SPARK 1.3.1 #####################################################

cd $DEMO_HOME;
# build from source spark and install artifacts locally in .m2
git clone https://github.com/apache/spark.git

SPARK_HOME=$DEMO_HOME/spark

cd $SPARK_HOME; 
git checkout v1.3.1; 
mvn -Pyarn -Phadoop-2.4 -Dhadoop.version=2.6.0 -Phive -Phive-thriftserver -DskipTests clean package install

cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
echo >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.cassandra.connection.host    localhost" >> $SPARK_HOME/conf/spark-defaults.conf

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
echo >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_LOCAL_IP=localhost" >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_MASTER_IP=localhost" >> $SPARK_HOME/conf/spark-env.sh

sed 's/log4j.rootCategory=INFO, console/log4j.rootCategory=WARN, console/' \
    $SPARK_HOME/conf/log4j.properties.template > $SPARK_HOME/conf/log4j.properties

#######################################################################

### SPARK-CASSANDRA_CONNECTOR #########################################

cd $DEMO_HOME;
# build from source spark and install artifacts locally in .m2
git clone https://github.com/datastax/spark-cassandra-connector.git

cd $DEMO_HOME/spark-cassandra-connector
git checkout adcf7892dbffff1faa401dd9e8b93ff54090e5ec

sbt/sbt clean assembly

#######################################################################

### ZEPPELIN ##########################################################

cd $DEMO_HOME
# build zeppelin from source using spark 1.3.1
git clone https://github.com/apache/incubator-zeppelin.git
ZEPPELIN_HOME=$DEMO_HOME/incubator-zeppelin

cd $ZEPPELIN_HOME
git checkout 4ca8466ab3d2c3bacee957ecf62b4e54f86820d7

mvn -Pspark-1.3 -Dspark.version=1.3.1 -Dhadoop.version=2.6.0 -Phadoop-2.4 -DskipTests clean package

cp $ZEPPELIN_HOME/conf/zeppelin-env.sh.template $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export MASTER=spark://localhost:7077" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export SPARK_HOME=$SPARK_HOME" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh 
echo "export ZEPPELIN_PORT=8888" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export ZEPPELIN_JAVA_OPTS=\"-Dspark.jars=$SPARK_CASSANDRA_CONNECTOR_HOME/spark-cassandra-connector-java/target/scala-2.10/spark-cassandra-connector-java-assembly-1.3.0-SNAPSHOT.jar\"" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh

#######################################################################
# That's all folks
