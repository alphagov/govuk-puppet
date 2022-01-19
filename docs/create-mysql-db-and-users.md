# Create MySQL database and user

## How to create a MySQL database/user on RDS instance

You'll need to know three things:

- Database name (find this in the [db.pp](https://github.com/alphagov/govuk-puppet/blob/31239642dfa7f8ba3984597f8242b9259a0e64f3/modules/govuk/manifests/apps/collections_publisher/db.pp#L5) of your app, e.g. `collections_publisher_production`)
- Database user (find this in [db.pp](https://github.com/alphagov/govuk-puppet/blob/31239642dfa7f8ba3984597f8242b9259a0e64f3/modules/govuk/manifests/apps/collections_publisher/db.pp#L6), or the [config/database.yml](https://github.com/alphagov/collections-publisher/blob/e77c397cef35865aa5198f41e463f2bb7f8e688c/config/database.yml#L4) of your app. Beware that some apps - Whitehall - have multiple users to create)
- Database user's password (you'll need to extract the value from govuk-secrets, e.g. [govuk::apps::collections_publisher::db::mysql_password](https://github.com/alphagov/govuk-secrets/blob/f4903188020c9cad4d55958ecf73fbb72c2bc0b2/puppet_aws/hieradata/apps/integration_credentials.yaml#L59). Make sure you look at the same environment, i.e. look in integration_credentials.yaml when making the database/user on Integration)

Connect to the DB admin machine, e.g.

```
gds govuk connect ssh -e integration collections_publisher_db_admin
```

Export the three bits of data:

```
export TMP_MYSQL_DB_NAME='collections_publisher_production' ;
export TMP_MYSQL_DB_USER='collections_pub' ;
export TMP_MYSQL_DB_PASSWORD='THE_PASSWORD' ;
```

Create the user:

```
sudo -H mysql -e "CREATE USER IF NOT EXISTS '$TMP_MYSQL_DB_USER'@'%' IDENTIFIED WITH 'mysql_native_password' BY '${TMP_MYSQL_DB_PASSWORD}';"
```

Create the database:

```
sudo -H mysql -e "CREATE DATABASE IF NOT EXISTS ${TMP_MYSQL_DB_NAME};"
```

Grant the user access to the database:

```
sudo -H mysql -e "GRANT ALL ON ${TMP_MYSQL_DB_NAME}.* TO '${TMP_MYSQL_DB_USER}'@'%'"
```

Finally, clean up after yourself:

```
unset TMP_MYSQL_DB_NAME ;
unset TMP_MYSQL_DB_USER ;
unset TMP_MYSQL_DB_PASSWORD ;
```

You can sense-check what you've done by:

```sh
# See which databases there are
sudo -H mysql -e "SHOW DATABASES;"

# See which users there are
sudo -H mysql -e "SELECT host, user FROM mysql.user;"

# See which tables are in the database, e.g.
sudo -H mysql -e "USE collections_publisher_production; SHOW TABLES;"
# Note that this will only be populated after the first data sync has run.
```

## How often does this need to be done?

Whenever we spin up a new RDS instance (i.e. rarely).

## Why must this be done manually?

In [#11353](https://github.com/alphagov/govuk-puppet/pull/11353) and [#11359](https://github.com/alphagov/govuk-puppet/pull/11359), new DB admin machines were created for apps that use MySQL. This was done as part of [RFC-143](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-143-split-database-instances.md), which agrees that every app should have its own RDS instance.

The [new RDS instances run MySQL version 8](https://github.com/alphagov/govuk-aws-data/blob/3445857dc7afd6644f4e5ccae5c5c6168e9b7281/data/app-govuk-rds/integration/common.tfvars#L47), where the previous shared RDS instance (`blue-mysql-primary`) is on version 5.6.

Traditionally, [we've used Puppet to create the MySQL databases and users](https://github.com/alphagov/govuk-puppet/blob/33dd118f4a37340b402839d790686098f1aac23a/modules/govuk/manifests/node/s_db_admin.pp) via the DB admin machine. However, this approach throws a SQL syntax error when applied to MySQL 8 environments:

```
Error: /Stage[main]/Govuk::Apps::Collections_publisher::Db/Mysql::Db[collections_publisher_production]/Mysql_user[collections_pub@%]/ensure: change from absent to present failed: Execution of '/usr/bin/mysql --defaults-extra-file=/root/.my.cnf --database=mysql -e CREATE USER 'collections_pub'@'%' IDENTIFIED BY PASSWORD '(omitted)'' returned 1: ERROR 1064 (42000) at line 1: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'PASSWORD '(omitted)'' at line 1
```

This is because [version 5.6 allowed the IDENTIFIED BY PASSWORD syntax](https://dev.mysql.com/doc/refman/5.6/en/create-user.html), whereas [8.0 is just IDENTIFIED BY](https://dev.mysql.com/doc/refman/8.0/en/create-user.html).

This [isn't overridable in the puppetlabs-mysql module](https://github.com/puppetlabs/puppetlabs-mysql/blob/a48069e89a4c06abccbb3595d2c782c7cd6e3254/lib/puppet/provider/mysql_user/mysql.rb#L66-L78), and whilst the issue has been [fixed](https://github.com/puppetlabs/puppetlabs-mysql/pull/1092) in later versions of the module, we use an old version of Puppet which does not allow us to upgrade the module.

A [spike](https://github.com/alphagov/govuk-puppet/pull/11373) investigated how we could use Puppet to create the database and user(s) in a MySQL 8 environment, but it had a number of unresolved complexities, so it was decided we would manually create the databases instead, given how infrequently we spin up new RDS instances.
