# == Class: hosts::production::management
#
# Manage /etc/hosts entries specific to machines in the management vDC
#
# === Parameters:
#
# [*app_domain*]
#   Domain to be used in vhost aliases
#
# [*apt_mirror_internal*]
#   Point `apt.production.alphagov.co.uk` to `apt-1` within this
#   environment. Instead of going to the Production VSE.
#   Default: false
#
class hosts::production::management (
  $app_domain,
  $apt_mirror_internal = false,
) {

  validate_bool($apt_mirror_internal)
  $apt_aliases = $apt_mirror_internal ? {
    true    => ['apt.production.alphagov.co.uk'],
    default => undef,
  }

  Govuk::Host {
    vdc => 'management',
  }

  govuk::host { 'jenkins-1':
    ip  => '10.0.0.3',
  }
  govuk::host { 'puppetmaster-1':
    ip              => '10.0.0.5',
    legacy_aliases  => ['puppet'],
    service_aliases => ['puppet', 'puppetdb'],
  }

  govuk::host { 'monitoring-1':
    ip              => '10.0.0.20',
    legacy_aliases  => ['monitoring', "nagios.${app_domain}"],
    service_aliases => ['alert', 'monitoring', 'nagios'],
  }

  govuk::host { 'graphite-1':
    ip              => '10.0.0.22',
    legacy_aliases  => ["graphite.${app_domain}"],
    service_aliases => ['graphite'],
  }
  govuk::host { 'logs-cdn-1':
    ip  => '10.0.0.27',
  }
  govuk::host { 'logging-1':
    ip              => '10.0.0.28',
    service_aliases => ['logging'],
  }
  govuk::host { 'logs-elasticsearch-1':
    ip              => '10.0.0.29',
    service_aliases => ['logs-elasticsearch'],
  }
  govuk::host { 'logs-elasticsearch-2':
    ip  => '10.0.0.30',
  }
  govuk::host { 'logs-elasticsearch-3':
    ip  => '10.0.0.31',
  }
  govuk::host { 'logs-redis-1':
    ip  => '10.0.0.40',
  }
  govuk::host { 'logs-redis-2':
    ip  => '10.0.0.41',
  }
  govuk::host { 'backup-1':
    ip  => '10.0.0.50',
  }
  govuk::host { 'apt-1':
    ip              => '10.0.0.75',
    legacy_aliases  => $apt_aliases,
    service_aliases => ['apt'],
  }
  govuk::host { 'jumpbox-1':
    ip  => '10.0.0.100',
  }
  govuk::host { 'mirrorer-1':
    ip  => '10.0.0.128',
  }
  govuk::host { 'jumpbox-2':
    ip  => '10.0.0.200',
  }
}
