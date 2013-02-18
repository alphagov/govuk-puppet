class collectd::plugin::curl_json {
  @collectd::plugin { '00-curl_json':
    content => "LoadPlugin curl_json\n",
  }
}
