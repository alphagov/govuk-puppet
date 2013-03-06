class performance_platform::backdrop {
  include pip
  include virtualenv

  $app_domain = extlookup('app_domain')

  govuk::app { "read.backdrop":
    app_type           => 'procfile',
    port               => 3038,
    enable_nginx_vhost => false,
  }

  govuk::app { "write.backdrop":
    app_type           => 'procfile',
    port               => 3039,
    enable_nginx_vhost => false,
  }
}

