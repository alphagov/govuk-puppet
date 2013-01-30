define datainsight::recorder($port) {

  $app_domain = extlookup('app_domain')

  govuk::app { "datainsight-${title}-recorder":
    app_type => 'rack',
    port     => $port,
  }

  govuk::app { "datainsight-${title}-recorder-listener":
    app_type           => 'procfile',
    port               => 'UNUSED',
    enable_nginx_vhost => false,
  }

  file { "/data/vhost/datainsight-${title}-recorder-listener.${app_domain}/current":
    ensure  => link,
    target  => "/data/vhost/datainsight-${title}-recorder.${app_domain}/current",
    require => File["/data/vhost/datainsight-${title}-recorder-listener.${app_domain}"],
  }

}
