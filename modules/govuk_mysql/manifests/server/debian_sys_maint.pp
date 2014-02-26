class govuk_mysql::server::debian_sys_maint {
  $debian_sys_maint_password = extlookup('mysql_debian_sys_maint', '')

  govuk_mysql::user { 'debian-sys-maint@localhost':
    password_hash => mysql_password($debian_sys_maint_password),
    table         => '*.*',
    privileges    => 'ALL',
  } ->
  file { '/etc/mysql/debian.cnf':
    content => template('govuk_mysql/etc/mysql/debian.cnf.erb'),
    mode    => '0600',
  }
}
