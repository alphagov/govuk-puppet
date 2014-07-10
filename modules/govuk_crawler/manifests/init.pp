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
# [*targets*]
#   An array of SSH user@host strings to sync the mirrored data to.
#   If populated then an Icinga passive check will be created.
#   If empty then no sync will be performed.
#   Default: []
#
# [*sshkeys*]
#   A hash of hostnames with ssh host keys and type of ssh host key.
#  Default: {}
class govuk_crawler(
  $enable = false,
  $ssh_private_key = '',
  $targets = [],
  $sshkeys = {}
) {
  validate_array($targets)
  validate_hash($sshkeys)

  include daemontools # provides setlock

  # set up user that's needed to upload the mirrored site to net storage
  govuk::user { 'govuk-netstorage':
    fullname => 'Netstorage Upload User',
    email    => 'webops@digital.cabinet-office.gov.uk',
  }
  file { '/home/govuk-netstorage/.ssh/id_rsa':
    ensure  => file,
    owner   => 'govuk-netstorage',
    mode    => '0600',
    content => $ssh_private_key,
    require => Govuk::User['govuk-netstorage'],
  }

  #create cron lock file writable by user
  file { '/var/run/govuk_update_and_upload_mirror.lock':
    ensure => present,
    mode   => '0700',
    owner  => 'govuk-netstorage',
  }

  # directory that we put the mirrored content into locally
  file { '/var/lib/govuk_mirror':
    ensure => directory,
    owner  => 'govuk-netstorage',
  }

  # script to mirror the site locally
  file { '/usr/local/bin/govuk_update_mirror':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/mirror/govuk_update_mirror',
  }

  $govuk_gemfury_source_url = hiera('govuk_gemfury_source_url')
  class {'ruby::govuk_mirrorer':
    govuk_gemfury_source_url => $govuk_gemfury_source_url,
  }

  # gem to generate report on pages with suspected bad links
  package { 'bad_link_finder':
    ensure   => '0.2.3',
    provider => system_gem,
  }

  # script that uploads the mirrored files to net storage
  file { '/usr/local/bin/govuk_upload_mirror':
    ensure  => present,
    mode    => '0755',
    content => template('mirror/govuk_upload_mirror.erb'),
  }

  # add ssh host keys of mirror targets.
  create_resources('sshkey',$sshkeys)

  $service_desc = 'mirrorer update and upload'
  $threshold_secs = 48 * (60 * 60)

  if !empty($targets) {
    @@icinga::passive_check { "check-mirror-sync-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
  }
  # parent script that is called by cron that calls the above scripts to do the mirroring
  file { '/usr/local/bin/govuk_update_and_upload_mirror':
    ensure  => present,
    mode    => '0755',
    content => template('mirror/govuk_update_and_upload_mirror.erb'),
    require => [File['/usr/local/bin/govuk_upload_mirror'],
                File['/usr/local/bin/govuk_update_mirror'],
                File['/var/lib/govuk_mirror']],
  }

  $cron_ensure = $enable ? {
    true    => present,
    default => absent,
  }

  cron { 'sync-to-mirror':
    ensure      => $cron_ensure,
    user        => 'govuk-netstorage',
    minute      => '0',
    environment => 'MAILTO=""',
    command     => '/usr/bin/setlock -n /var/run/govuk_update_and_upload_mirror.lock /usr/local/bin/govuk_update_and_upload_mirror',
    require     => [File['/usr/local/bin/govuk_update_and_upload_mirror'],
                    File['/var/run/govuk_update_and_upload_mirror.lock']],
  }

}
