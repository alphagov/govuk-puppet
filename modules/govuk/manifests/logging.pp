class govuk::logging {
  # tagalog provides logship, used by govuk_logpipe
  package { 'tagalog':
    ensure   => '0.2.5',
    provider => 'pip',
  }

  # govuk_logpipe pipes application logs
  file { '/usr/local/bin/govuk_logpipe':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_logpipe',
    mode    => '0755',
    require => Package['tagalog'],
  }
}
