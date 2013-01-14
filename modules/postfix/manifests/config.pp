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
                command => "/usr/sbin/postmap /etc/postfix/sasl_passwd",
                refreshonly => true,
                require => [
                        File["/etc/postfix/sasl_passwd"],
                        Package["postfix"]],
  }
}
