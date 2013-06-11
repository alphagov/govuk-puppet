class govuk::apps::backdrop_ga_realtime_collector {
  datainsight::collector { 'backdrop-ga-realtime-collector':
    vhost => 'backdrop-ga-realtime-collector'
  }
}
