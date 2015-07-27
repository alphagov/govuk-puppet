# == Class: collectd::plugin::curl
#
# Setup a collectd plugin to retrieve files with curl.
#
class collectd::plugin::curl {
  @collectd::plugin { 'curl':
    prefix  => '00-',
  }
}
