# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::whitehall::db (
  $mysql_whitehall_admin = '',
  $whitehall_fe_password = '',
){

  $hashed_whitehall_admin_password = mysql_password($mysql_whitehall_admin)
  $mysql_command = 'mysql --defaults-extra-file=/root/.my.cnf'

  exec { 'create_whitehall_user':
    command => "${mysql_command} -e \"CREATE USER IF NOT EXISTS 'whitehall'@'%' IDENTIFIED WITH 'mysql_native_password' AS '${hashed_whitehall_admin_password}';\"";
  }

  exec { 'create_whitehall_production_db':
    command => "${mysql_command} -e \"CREATE DATABASE IF NOT EXISTS whitehall_production;\"";
  }

  exec { 'grant_whitehall_user':
    command => "${mysql_command} -e \"GRANT ALL ON whitehall_production.* TO 'whitehall'@'%';\"",
    require => [ Exec['create_whitehall_user'], Exec['create_whitehall_production_db'] ];
  }

  $hashed_whitehall_fe_password = mysql_password($whitehall_fe_password)

  exec { 'create_whitehall_fe_user':
    command => "${mysql_command} -h whitehall-mysql -e \"CREATE USER IF NOT EXISTS 'whitehall_fe'@'%' IDENTIFIED WITH 'mysql_native_password' AS '${hashed_whitehall_fe_password}';\"";
  }

  exec { 'grant_whitehall_fe_user':
    command => "${mysql_command} -e \"GRANT SELECT ON whitehall_production.* TO 'whitehall_fe'@'%';\"",
    require => [ Exec['create_whitehall_fe_user'], Exec['create_whitehall_production_db'] ];
  }

  # mysql::db { 'whitehall_production':
  #   user     => 'whitehall',
  #   host     => '%',
  #   password => $mysql_whitehall_admin,
  # }
  #
  # govuk_mysql::user { 'whitehall_fe@%':
  #   password_hash => mysql_password($whitehall_fe_password),
  #   table         => 'whitehall_production.*',
  #   privileges    => ['SELECT'],
  #   require       => Mysql::Db['whitehall_production'],
  # }
}
