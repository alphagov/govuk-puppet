class govuk::apps::backdrop_pingdom_collector {
  datainsight::collector { 'backdrop-pingdom-collector':
    vhost => 'backdrop-pingdom-collector'
  }
}
