# Clustering check-in's with Spark

## Summary
Spark and Cassandra provide a good alternative to traditional big data architectures based on Hadoop, by bringing the operational and the analytic world closer to each other. In this post/tutorial I will show how to combine Cassandra and Spark to get the best of those two technologies.

As a demo we will cluster check-in transactions in New York using the gowalla dataset. Clustering will be performed on Spark using the ml-lib library of spark and data will be extracted from cassandra using the Spark-Cassandra connector.

Tutorial: http://www.natalinobusa.com/2015/07/clustering-check-ins-with-spark-and.html

### Install and Setup

The full tutorial, including install script, data munging and analysis with scikit-learn in python notebooks and data analysis with Spark zeppeling notebooks are available as a github  project. Check out the code at https://github.com/natalinobusa/gowalla-spark-demo

##### Versions

Matching version is quite important when working with this set of technologies. The demo provided here below is tested on the following versions;

  - cassandra 2.1.7
  - spark 1.3.1
  - spark-cassandra connector 1.3
  - zeppelin (master github)
  
##### Requirements
  - jdk  1.7 or higher 
  - git
  - npm
  - maven 
  - curl
  - wget

##### Setup
You need to have Cassandra, Spark and Zeppeling running on your system in order to proceed. For those of you who want to give it a try, I have written a very rudimental script which downloads, builds and install all the necessary tools on a local directory (no admin required).

First clone the project from github, then run the `install.sh` script. Since the script will build Spark and Zeppelin from source, it's gonna take a while. I am planning to test the pre-built Spark when I have some more time.

```sh
git clone https://github.com/natalinobusa/gowalla-spark-demo.git gowalla-spark-demo
cd gowalla-spark-demo
./install.sh
```

##### Run it!
Again, I have prepared a script `start-all.sh`, which runs all the various ingredients. A similar script `stop-all.sh` is available to stop all services.
Spark is configured to run in cluster mode (albeit on a single node), a password might be prompted, since the master and the workers of spark communicate via ssh.

Some headstart:
- Spark web interface: http://localhost:8080/
- Zeppelin: http://localhost:8888/

Cassandra can be accessed with the cqlsh command line interface. After installing and seting up the system, type `./apache-cassandra-2.1.7/bin/cqlsh` from the root of the git project, to start the cql client.
