class govuk_mysql::server::debian_sys_maint ( $root_password ) {
  $debian_sys_maint_password = extlookup('mysql_debian_sys_maint', '')

  govuk_mysql::user { 'debian-sys-maint':
    root_password => $root_password,
    user_password => $debian_sys_maint_password,
    remote_host   => 'localhost',
  }

  file { '/etc/mysql/debian.cnf':
    content => template('govuk_mysql/etc/mysql/debian.cnf.erb'),
    mode    => '0600',
    require => Govuk_mysql::User['debian-sys-maint'],
  }
}
