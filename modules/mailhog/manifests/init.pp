# == Class: MailHog
#
# Installs the MailHog package.
#
# Uses the -> operator to ensure the script is run from
# top to bottom to ensure things are done in the correct
# order.
#
class mailhog {
  exec { 'get-mailhog-from-github':
    command => '/usr/bin/wget -q https://github.com/mailhog/MailHog/releases/download/v0.2.1/MailHog_linux_amd64 -O /usr/bin/mailhog',
    creates => '/usr/bin/mailhog',
  } ->

  file { '/usr/bin/mailhog':
    ensure  => present,
    mode    => '0755',
    require => Exec['get-mailhog-from-github'],
  } ->

  file { '/etc/init.d/mailhog':
    ensure  => present,
    mode    => '0755',
    content => template("${module_name}/mailhog.erb"),
  } ->

  service { 'mailhog':
    ensure     => running,
    hasrestart => true,
  }
}
