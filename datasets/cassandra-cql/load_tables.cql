/*
  If you prefer to have the date in UTC format as default, set the TZ env variable to UTC
  TZ=UTC ../../apache-cassandra-2.1.7/bin/cqlsh
*/

USE lbsn;

TRUNCATE checkins;
COPY checkins (year,month,day,time,ts,uid,lat,lon,vid) FROM '../checkins.csv' ;

TRUNCATE venues;
COPY venues (vid,name,lat,lon) FROM '../venues.csv' ;