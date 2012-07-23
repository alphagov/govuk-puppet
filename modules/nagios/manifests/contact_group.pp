define nagios::contact_group ($email) {
  $contact_email = $email
  file { '/etc/nagios3/conf.d/contacts_nagios2.cfg':
    content => template("nagios/contacts_nagios2.cfg.erb"),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
}