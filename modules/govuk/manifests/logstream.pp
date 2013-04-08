# == Define: govuk::logstream
#
# Creates an upstart job which tails a logfile and sends it to govuk_logpipe.
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

# [*enable*]
#   If set to false any existing logstream jobs will be removed. Defaults to true.
#
# [*host*]
#   Adds a host field. Defaults to $::fqdn.
#
# [*json*]
#   Whether the log is in json format. Defaults to false.
#
define govuk::logstream (
  $logfile,
  $tags = [],
  $fields = {},
  $enable = true,
  $host = $::fqdn,
  $json = false
) {

  # TODO: Change the `enable => false` to a more Puppet-esque
  # `ensure => absent` interface?
  if ($enable == true and $::govuk_platform != 'development') {
    $tag_string = join($tags, ' ')

    file { "/etc/init/logstream-${title}.conf":
      ensure  => present,
      content => template('govuk/logstream.erb'),
      notify  => Service["logstream-${title}"],
    }

    service { "logstream-${title}":
      ensure    => running,
      provider  => 'upstart',
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
