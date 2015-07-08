/*
  If you prefer to have the date in UTC format as default, set the TZ env variable to UTC
  TZ=UTC ../../apache-cassandra-2.1.7/bin/cqlsh
*/

USE lbsn;

/* query a given day */
select * from lbsn.checkins where year=2010 and month=9 and day=13 limit 5;

/* range by date day */
select * from checkins where year=2010 and month=9 and day<16 and day>13 limit 5;

/* within a day, range by time between 17:00:00 and 18:00:00*/
select * from checkins where year=2010 and month=9 and day=13 and time>61200 and time<64800  limit 5;

/* INVALID!: range by date and by time */
select * from checkins where year=2010 and month=9 and day>13 and day<16 and time>61200 and time<64800  limit 5;

