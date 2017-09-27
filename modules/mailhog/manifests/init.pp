# == Class: MailHog
#
# Manages the MailHog package, service and configuration
#
class mailhog {
  exec { 'get-mailhog-from-github':
    command => '/usr/bin/wget -q https://github.com/mailhog/MailHog/releases/download/v0.2.1/MailHog_linux_amd64 -O /usr/bin/mailhog',
    creates => '/usr/bin/mailhog',
  }

  file { '/usr/bin/mailhog':
    ensure  => present,
    mode    => '0755',
    require => Exec['get-mailhog-from-github'],
  }

  file { '/etc/init.d/mailhog':
    ensure  => present,
    mode    => '0755',
    content => file("${module_name}/mailhog.erb"),
    require => File['/usr/bin/mailhog'],
    notify  => Service['mailhog'],
  }

  service { 'mailhog':
    ensure     => running,
    hasrestart => true,
    require    => File['/etc/init.d/mailhog'],
  }
}
