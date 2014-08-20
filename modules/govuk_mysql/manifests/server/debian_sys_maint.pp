# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
