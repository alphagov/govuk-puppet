define datainsight::recorder($port) {

  $domain = extlookup('app_domain')

  govuk::app { "datainsight-${title}-recorder":
    app_type => 'rack',
    port     => $port,
  }

  govuk::app { "datainsight-${title}-recorder-listener":
    app_type           => 'procfile',
    port               => 'UNUSED',
    enable_nginx_vhost => false,
  }

  file { "/data/vhost/datainsight-${title}-recorder-listener.${domain}/current":
    ensure  => link,
    target  => "/data/vhost/datainsight-${title}-recorder.${domain}/current",
    require => File["/data/vhost/datainsight-${title}-recorder-listener.${domain}"],
  }

}
