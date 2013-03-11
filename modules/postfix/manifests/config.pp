class postfix::config(
  $smarthost,
  $smarthost_user,
  $smarthost_pass
) {

  file { '/etc/mailname':
    ensure  => present,
    content => "${::fqdn}\n",
  }

  file { "/etc/postfix/main.cf":
    content => template("postfix/etc/postfix/main.cf.erb"),
    notify  => Service[postfix],
    require => File['/etc/mailname'],
  }

  if $smarthost {
    $email_list   = extlookup('email_list', 'noemail')
    $email_domain = extlookup('email_domain', 'localhost')

    postfix::postmapfile { 'outbound_rewrites':     name => 'outbound_rewrites' }
    postfix::postmapfile { 'local_remote_rewrites': name => 'local_remote_rewrites' }

    if ($smarthost_user and $smarthost_pass) {
      postfix::postmapfile { 'sasl_passwd': name => 'sasl_passwd' }
    }
  }

}
