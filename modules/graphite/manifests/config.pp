class graphite::config {

  file { '/opt/graphite/graphite/manage.py':
    mode => '0755',
  }

  file { '/opt/graphite/graphite/local_settings.py':
    source  => 'puppet:///modules/graphite/local_settings.py',
  }

  file { '/opt/graphite/conf/carbon.conf':
    source => 'puppet:///modules/graphite/carbon.conf',
  }

  file { '/opt/graphite/conf/storage-schemas.conf':
    source => 'puppet:///modules/graphite/storage-schema.conf',
  }

  exec { 'create whisper db for graphite' :
    command     => '/opt/graphite/graphite/manage.py syncdb --noinput',
    creates     => '/opt/graphite/storage/graphite.db',
    environment => ['GRAPHITE_STORAGE_DIR=/opt/graphite/storage/','GRAPHITE_CONF_DIR=/opt/graphite/conf/']
  }

  $domain = $::govuk_platform ? {
    'development' => 'dev.gov.uk',
    default       => "${::govuk_platform}.alphagov.co.uk",
  }

  nginx::config::vhost::proxy { "graphite.${domain}":
    to   => ['localhost:33333'],
    root => '/opt/graphite/webapp',
  }

  file { '/etc/init/graphite.conf':
    source => 'puppet:///modules/graphite/etc/init/graphite.conf',
  }

  file { '/etc/init/carbon_cache.conf':
    source => 'puppet:///modules/graphite/etc/init/carbon_cache.conf',
  }

  @@nagios::check { "check_carbon_cache_running_on_${::hostname}":
    check_command       => 'check_nrpe_1arg!/usr/lib/nagios/plugins/check_procs -a carbon-cache 1:',
    service_description => "check if carbon-cache is running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
