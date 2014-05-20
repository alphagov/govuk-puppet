define icinga::slack_contact (
  $slack_subdomain,
  $slack_token,
  $slack_channel,
  $slack_username = 'Icinga',
  $nagios_cgi_url = 'https://example.org/cgi-bin/icinga/status.cgi'
) {

  include icinga::config::slack

  file {"/etc/icinga/conf.d/contact_${name}.cfg":
    content => template('icinga/slack_contact.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
