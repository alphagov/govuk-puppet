class postfix::config {

  $amazon_ses_key    = extlookup('amazon_ses_key','NO_SES_KEY')
  $amazon_ses_secret = extlookup('amazon_ses_secret','NO_SES_SECRET')
  $email_list        = extlookup('email_list','noemail')
  $email_domain      = extlookup('email_domain','localhost')

  file { "/etc/postfix/main.cf":
    content => template("postfix/etc/postfix/main.cf.erb"),
    notify  => Service[postfix]
  }

  postfix::postmapfile { 'sasl_passwd':           name => 'sasl_passwd' }
  postfix::postmapfile { 'outbound_rewrites':     name => 'outbound_rewrites' }
  postfix::postmapfile { 'local_remote_rewrites': name => 'local_remote_rewrites' }

}
