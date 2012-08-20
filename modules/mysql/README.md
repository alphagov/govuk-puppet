# mysql replication instructions

Puppet can create mysql servers using the mysql::server class. You
will also want to use replica_user to create a replica user on the
master; you will then manually tell the slave about the replica user
credentials (see below).

## Master

Before taking the dump from the master, all commits to the database
should be blocked (otherwise the binary log on the master changes and
the slave won't sync). Although apparently --master-data implies
--lock-all-tables.

You need to create a sql dump for all databases from the master:

    mysqldump -u root -p --all-databases --master-data --add-drop-database > dump.sql

The command will prompt for the root password.

Source: http://dev.mysql.com/doc/refman/5.1/en/replication-howto-mysqldump.html

## Slave

Now you need to restore the dump to the slave- you can confirm the password in common.csv

    mysql  -root -p < dump.sql

Then you need to set the replication on the slave

    STOP SLAVE;
    CHANGE MASTER TO
           MASTER_HOST='**HOSTNAME**',
           MASTER_USER='replica_user',
           MASTER_PASSWORD='**REPLICA PASSWORD**';
    START SLAVE;
    SHOW SLAVE STATUS \G;

If it worked then you should see 'Slave_IO_State: Waiting for master to send event' as the first line of the 'show slave status' command.

Please see the following for further information and common questions:

http://dev.mysql.com/doc/refman/5.1/en/faqs-replication.html
