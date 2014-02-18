# == Class: govuk_mysql::server::root_password
#
# This is a HACK to transition an existing MySQL server installation to the
# puppetlabs/mysql module. If a `root_password` is set then for the first
# Puppet run on an existing machine it modifies the relationships of so that
# the password file is written before attempting to set the root password
# and both occur before any user or grant resources.
#
# https://github.com/puppetlabs/puppetlabs-mysql/issues/331
# https://github.com/puppetlabs/puppetlabs-mysql/issues/340
#
# It can be removed when deployed to all existing nodes.
#
class govuk_mysql::server::root_password inherits mysql::server::root_password {
  if $::mysql_old_install and $::mysql::server::root_password != 'UNSET' {
    File["${::root_home}/.my.cnf"] {
      require => undef,
    }

    Mysql_user['root@localhost'] {
      require => File["${::root_home}/.my.cnf"],
    }

    Class['mysql::server::root_password'] -> Mysql_User <| title != 'root@localhost' |>
    Class['mysql::server::root_password'] -> Mysql_Grant <||>
  }
}
