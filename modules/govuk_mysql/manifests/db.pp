# == Class: Govuk_mysql::Db
#
# This defined type is a direct copy from the upstream MySQL Puppet module,
# save for the fact it does not explictly require the mysql::server class. This
# is so we can transparently manage remote MySQL servers without having to install
# a MySQL server on our admin instance.
#
#
define govuk_mysql::db (
  $user,
  $password,
  $charset     = 'utf8',
  $collate     = 'utf8_general_ci',
  $host        = 'localhost',
  $grant       = 'ALL',
  $sql         = '',
  $enforce_sql = false,
  $ensure      = 'present'
) {
  #input validation
  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure. Allowed values are 'present' and 'absent'.")
  $table = "${name}.*"

  include '::mysql::client'

  if $::aws_migration {
    mysql_database { $name:
      ensure   => $ensure,
      charset  => $charset,
      collate  => $collate,
      provider => 'mysql',
      require  => Class['mysql::client'],
      before   => Mysql_user["${user}@${host}"],
    }
  } else {
    mysql_database { $name:
      ensure   => $ensure,
      charset  => $charset,
      collate  => $collate,
      provider => 'mysql',
      require  => [ Class['mysql::server'], Class['mysql::client'] ],
      before   => Mysql_user["${user}@${host}"],
    }
  }

  if $::aws_migration {
    $user_resource = {
      ensure        => $ensure,
      password_hash => mysql_password($password),
      provider      => 'mysql',
    }
  } else {
    $user_resource = {
      ensure        => $ensure,
      password_hash => mysql_password($password),
      provider      => 'mysql',
      require       => Class['mysql::server'],
    }
  }

  ensure_resource('mysql_user', "${user}@${host}", $user_resource)

  if $ensure == 'present' {
    if $::aws_migration {
      mysql_grant { "${user}@${host}/${table}":
        privileges => $grant,
        provider   => 'mysql',
        user       => "${user}@${host}",
        table      => $table,
        require    => Mysql_user["${user}@${host}"],
      }
    } else {
      mysql_grant { "${user}@${host}/${table}":
        privileges => $grant,
        provider   => 'mysql',
        user       => "${user}@${host}",
        table      => $table,
        require    => [ Mysql_user["${user}@${host}"], Class['mysql::server'] ],
      }
    }

    $refresh = ! $enforce_sql

    if $sql {
      exec{ "${name}-import":
        command     => "/usr/bin/mysql ${name} < ${sql}",
        logoutput   => true,
        environment => "HOME=${::root_home}",
        refreshonly => $refresh,
        require     => Mysql_grant["${user}@${host}/${table}"],
        subscribe   => Mysql_database[$name],
      }
    }
  }
}
