class ganglia::config {

  include govuk::htpasswd

  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))

  $protect_monitoring = str2bool(extlookup('monitoring_protected','yes'))
  nginx::config::ssl { 'ganglia':
    certtype => 'wildcard_alphagov' }
  nginx::config::site { 'ganglia':
    content => template('ganglia/nginx.conf.erb'),
  }
  nginx::log {  [
                'ganglia-access.log',
                'ganglia-error.log'
                ]:
                  logstream => true;
  }

  file { '/var/lib/ganglia/dwoo':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
  file { '/var/lib/ganglia/dwoo/compiled':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
  file { '/var/lib/ganglia/dwoo/cache':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
  file { '/var/lib/ganglia/conf':
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }

  # TODO: this config file contains a hack to drop priveleges to "ganglia"
  # and not "nobody" (the default). This is because in lucid, installing
  # ganglia-monitor has the brain-dead behaviour of chowning
  # /var/lib/ganglia/rrds to ganglia:ganglia instead of nobody:ganglia.
  #
  # This bug in ganglia-monitor is fixed in maverick [1], so if we upgrade to
  # precise, this config file will actually break gmetad, because
  # /var/lib/ganglia/rrds will once more be owned by nobody. >_<
  # [1] https://bugs.launchpad.net/ubuntu/+source/ganglia/+bug/444485
  #  -- PP, 2012-08-15
  file { '/etc/ganglia/gmetad.conf':
    source  => 'puppet:///modules/ganglia/gmetad.conf',
    owner   => root,
    group   => root,
    require => Exec[ganglia_webfrontend_untar],
  }
}
