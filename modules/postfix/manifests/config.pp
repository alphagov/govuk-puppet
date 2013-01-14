class postfix::config {

  $amazon_ses_key    = extlookup('amazon_ses_key','NO_SES_KEY')
  $amazon_ses_secret = extlookup('amazon_ses_secret','NO_SES_SECRET')

  file { "/etc/postfix/main.cf":
    content => template("postfix/etc/postfix/main.cf.erb"),
    notify  => Service[postfix]
  }

  file { "/etc/postfix/sasl_passwd":
    content => template("postfix/etc/postfix/sasl_passwd.erb"),
    notify  => Exec[postmap_sasl_passwd]
  }

  exec { "postmap_sasl_passwd":
                command      => "/usr/sbin/postmap /etc/postfix/sasl_passwd",
                refreshonly  => true,
                require      => [
                                  File["/etc/postfix/sasl_passwd"],
                                  Package["postfix"]
                                ],
  }

  file { "/etc/postfix/outbound_rewrites":
    content => template("postfix/etc/postfix/outbound_rewrites.erb"),
    notify  => Exec[postmap_outbound_rewrites]
  }

  exec { "postmap_outbound_rewrites":
                command      => "/usr/sbin/postmap /etc/postfix/outbound_rewrites",
                refreshonly  => true,
                require      => [
                                  File["/etc/postfix/outbound_rewrites"],
                                  Package["postfix"]
                                ],
  }

  file { "/etc/postfix/local_remote_rewrites":
    content => template("postfix/etc/postfix/local_remote_rewrites.erb"),
    notify  => Exec[postmap_local_remote_rewrites]
  }

  exec { "postmap_local_remote_rewrites":
                command      => "/usr/sbin/postmap /etc/postfix/local_remote_rewrites",
                refreshonly  => true,
                require      => [
                                  File["/etc/postfix/local_remote_rewrites"],
                                  Package["postfix"]
                                ],
  }

}
