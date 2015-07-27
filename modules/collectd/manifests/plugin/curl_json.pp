# == Class: collectd::plugin::curl_json
#
# Setup a collectd plugin to retrieve JSON data with curl.
#
class collectd::plugin::curl_json {
  @collectd::plugin { 'curl_json':
    prefix  => '00-',
  }
}
