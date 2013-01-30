class graphite::config {

  $vhost = 'graphite.*'

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

  nginx::config::vhost::proxy { 'graphite':
    to      => ['localhost:33333'],
    aliases => [$vhost],
    root    => '/opt/graphite/webapp',
    aliases => ["graphite.production-ec2.alphagov.co.uk"],
  }

  file { '/etc/init/graphite.conf':
    source => 'puppet:///modules/graphite/etc/init/graphite.conf',
  }

  file { '/etc/init/carbon_cache.conf':
    source => 'puppet:///modules/graphite/etc/init/carbon_cache.conf',
  }

  @@nagios::check { "check_carbon_cache_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running_with_arg!python carbon-cache',
    service_description => "carbon-cache running",
    host_name           => $::fqdn,
  }

}
