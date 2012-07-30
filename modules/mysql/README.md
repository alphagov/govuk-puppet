# mysql replication instructions

Puppet will create the master and slave nodes and the user to replicate data (replica_user) but you will need to manually replicate the data when you bring up a new slave

The slave class is called from puppet:

    class {'mysql::server::slave':
      database         => 'need_o_tron_production',
      user             => 'need_o_tron',
      password         => $needotron_password,
      host             => 'localhost',
      #replica_password => $replica_password,
      root_password    => $mysql_password,
      slave_server_id       => $govuk_mysql_server_id, #server_id is a fact because it has to be unique for each slave
      master_host           => 'preview-mongo-client-20111213143425-01-external.hosts.alphagov.co.uk',
    }


## Master

Before taking the dump from the master, all commits to the database should be blocked (otherwise the binary log on the master changes and the slave won't sync)

    SHOW MASTER STATUS;

this values gets used further down when we do the initial sync of the master & slave

http://dev.mysql.com/doc/refman/5.0/en/replication-howto-masterstatus.html

Then you need to create the sql dump from the master- you can confirm the db name and password from common.csv

    mysqldump -h **HOST IP** -uneed_o_tron -p'**PASSWORD**' --database **DATABASE NAME** >dump.sql

## Slave

Now you need to restore the dump to the slave- you can confirm the password in common.csv

    mysql  -uneed_o_tron -p'**PASSWORD**' < dump.sql;
    mysql  -root -p'**PASSWORD**' < dump.sql;

Then you need to set the replication on the slave

The values <FILE> and <POSITION> in the following query come from the 'SHOW MASTER STATUS;' command that you did on the mysql master.

    STOP SLAVE;
    CHANGE MASTER TO
           MASTER_HOST='**IP ADDRESS**',
           MASTER_USER='replica_user',
           MASTER_PASSWORD='**REPLICA PASSWORD**',
           MASTER_LOG_FILE='<FILE>',
           MASTER_LOG_POS=<POSITION>;
    START SLAVE;
    SHOW SLAVE STATUS \G;

If it worked then you should see 'Slave_IO_State: Waiting for master to send event' as the first line of the 'show slave status' command.

Please see the following for further information and common questions:

http://dev.mysql.com/doc/refman/5.1/en/faqs-replication.html
