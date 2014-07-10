# == Class: GOV.UK Crawler
#
# Crawl GOV.UK and upload it to a remote static mirror for failover purposes.
#
# === Parameters
#
# [*enable*]
#   Whether to setup the cronjob. If `false` this will prevent the update
#   AND upload processes from running, regardless of the `targets` param.
#   Default: false
#
# [*ssh_keys*]
#   A hash of hostnames with ssh host keys and type of ssh host key.
#   Default: {}
#
# [*targets*]
#   An array of SSH user@host strings to sync the mirrored data to.
#   If populated then an Icinga passive check will be created.
#   If empty then no sync will be performed.
#   Default: []
#
class govuk_crawler(
  $enable = false,
  $ssh_keys = {}
  $ssh_private_key = '',
  $targets = [],
) {
  validate_array($targets)
  validate_hash($ssh_keys)

  $crawler_user = 'govuk-crawler'
  $crawler_lock_path = '/var/run/govuk_sync_mirror.lock'
  $sync_script_name = 'govuk_sync_mirror'
  $sync_script_path = "/usr/local/bin/${sync_script_name}"
  $mirror_root = '/mnt/crawler-worker'

  include daemontools # provides setlock

  # add ssh host keys of mirror targets.
  create_resources('sshkey', $ssh_keys)

  # User used to rsync crawled content to the remote mirror
  govuk::user { $crawler_user:
    fullname => 'GOV.UK Crawler',
    email    => 'webops@digital.cabinet-office.gov.uk',
  }
  file { "/home/${crawler_user}/.ssh/id_rsa":
    ensure  => file,
    owner   => $crawler_user,
    mode    => '0600',
    content => $ssh_private_key,
    require => Govuk::User[$crawler_user],
  }

  #create cron lock file writable by user
  file { $crawler_lock_path:
    ensure => present,
    mode   => '0700',
    owner  => $crawler_user,
  }

  # directory used by GOV.UK Crawler Worker to store crawled content
  file { $mirror_root:
    ensure => directory,
    mode   => '0750',
    owner  => $crawler_user,
  }

  # sync crawled content to remote mirror
  file { $sync_script_path:
    ensure  => present,
    mode    => '0750',
    content => template("${module_name}/${sync_script_name}.erb"),
    owner   => $crawler_user,
  }

  $govuk_gemfury_source_url = hiera('govuk_gemfury_source_url')
  class {'ruby::govuk_seed_crawler':
    govuk_gemfury_source_url => $govuk_gemfury_source_url,
  }

  # gem to generate report on pages with suspected bad links
  package { 'bad_link_finder':
    ensure   => '0.2.3',
    provider => system_gem,
  }

  $service_desc = 'Mirror sync'
  $threshold_secs = 24 * (60 * 60)

  if !empty($targets) {
    @@icinga::passive_check { "check-mirror-sync-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
  }

  $cron_ensure = $enable ? {
    true    => present,
    default => absent,
  }

  cron { 'sync-to-mirror':
    ensure      => $cron_ensure,
    user        => $crawler_user,
    minute      => '0',
    environment => 'MAILTO=""',
    command     => "/usr/bin/setlock -n ${$crawler_lock_path} ${sync_script_path}",
    require     => [File[$sync_script_path], File[$crawler_lock_path]]
  }

}
