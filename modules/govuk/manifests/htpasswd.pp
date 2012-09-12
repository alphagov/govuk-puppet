class govuk::htpasswd {

  file { '/etc/govuk.htpasswd':
    ensure => 'present',
    source => 'puppet:///modules/govuk/govuk.htpasswd',
  }

}
