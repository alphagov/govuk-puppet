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
# [*ensure*]
#   If set to absent any existing logstream jobs will be removed. Defaults to present.
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
  $ensure = present,
  $tags = [],
  $fields = {},
  $json = false,
  $statsd_metric = undef,
  $statsd_timers = []
) {

  validate_re($ensure, ['^present$','^absent$'])

  # added to whitelist in lib/puppet-lint/plugins/check_hiera.rb
  # this is necessary because it is a global override in a defined type
  $disable_logstreams = hiera('govuk::logstream::disabled', false)
  validate_bool($disable_logstreams)

  if ($disable_logstreams) {
    # noop
  } elsif ($ensure == present) {
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
