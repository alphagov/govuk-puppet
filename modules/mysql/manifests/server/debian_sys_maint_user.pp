class mysql::server::debian_sys_maint_user ( $root_password ) {
  $debian_sys_maint_password = extlookup('mysql_debian_sys_maint', '')

  mysql::user { 'debian-sys-maint':
    root_password => $root_password,
    user_password => $debian_sys_maint_password,
    remote_host   => 'localhost',
  }

}
