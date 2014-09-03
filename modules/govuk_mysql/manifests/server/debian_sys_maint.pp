# == Class: govuk_mysql::server::debian_sys_maint
#
# Class to control the debian-sys-maint user for mysql.
#
# === Parameters
#
# [*mysql_debian_sys_maint*]
#   A password for the debian-sys-maint-user
#
class govuk_mysql::server::debian_sys_maint (
  $mysql_debian_sys_maint = '',
){
  govuk_mysql::user { 'debian-sys-maint@localhost':
    password_hash => mysql_password($mysql_debian_sys_maint),
    table         => '*.*',
    privileges    => 'ALL',
  } ->
  file { '/etc/mysql/debian.cnf':
    content => template('govuk_mysql/etc/mysql/debian.cnf.erb'),
    mode    => '0600',
  }
}
