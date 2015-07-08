/*
  If you prefer to have the date in UTC format as default, set the TZ env variable to UTC
  TZ=UTC ../../apache-cassandra-2.1.7/bin/cqlsh
*/

CREATE KEYSPACE IF NOT EXISTS lbsn 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE lbsn;

CREATE TABLE checkins (
  year  int, 
  month int, 
  day   int,
  time  int,
  ts    timestamp,
  uid   bigint,
  lat   double,
  lon   double,
  vid   bigint,
  PRIMARY KEY ((year, month), day, time, uid)
) WITH CLUSTERING ORDER BY (day ASC, time ASC, uid ASC);

CREATE TABLE venues (
  vid   bigint, 
  name  text,
  lat   double,
  lon   double,
  PRIMARY KEY (vid)
);

CREATE TABLE clusters (
  ts    timestamp,
  cid   int, 
  lat   double,
  lon   double,
  PRIMARY KEY ((ts, cid))
);