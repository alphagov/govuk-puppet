class performance_platform::backstage {

  $app_domain = extlookup('app_domain')

  govuk::app { "read.backstage":
    app_type           => 'procfile',
    port               => 3037,
    enable_nginx_vhost => false,
  }

  govuk::app { "write.backstage":
    app_type           => 'procfile',
    port               => 3038,
    enable_nginx_vhost => false,
  }
}

