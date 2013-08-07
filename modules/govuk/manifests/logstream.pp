# == Define: govuk::logstream
#
# Creates an upstart job which tails a logfile and sends it to logship from tagalog.
#
# == Parameters
# [*logfile*]
#   Full path of the log to tail.
#
# [*tags*]
#   Optional array of strings to tag each request.
#
# [*fields*]
#   Optional hash of key=value pairs to add to each request.
#
# [*enable*]
#   If set to false any existing logstream jobs will be removed. Defaults to true.
#
# [*json*]
#   Whether the log is in json format. Defaults to false.
#
# [*statsd_metric*]
#   if defined, specifies statsd metric (in logship's CLI format) to
#   send to statsd. Defaults to undef.
#
define govuk::logstream (
  $logfile,
  $tags = [],
  $fields = {},
  $enable = true,
  $json = false,
  $statsd_metric = undef,
  $statsd_timers = []
) {

  # TODO: Change the `enable => false` to a more Puppet-esque
  # `ensure => absent` interface?
  if ($::govuk_platform == 'development') {
    # noop
  } elsif ($enable == true) {
    file { "/etc/init/logstream-${title}.conf":
      ensure    => present,
      content   => template('govuk/logstream.erb'),
      notify    => Service["logstream-${title}"],
      subscribe => Class['govuk::logging'],
    }

    service { "logstream-${title}":
      ensure    => running,
      provider  => 'upstart',
      subscribe => Class['govuk::logging'],
    }
  } else {
    file { "/etc/init/logstream-${title}.conf":
      ensure  => absent,
      require => Exec["logstream-STOP-${title}"],
    }

    exec { "logstream-STOP-${title}" :
      command => "initctl stop logstream-${title}",
      onlyif  => "initctl status logstream-${title}",
    }
  }

}
