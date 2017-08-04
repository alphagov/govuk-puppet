# == Class: GOV.UK Crawler
#
# Crawl GOV.UK and upload it to a remote static mirror for failover purposes.
#
# === Parameters
#
# [*amqp_exchange*]
#   The RabbitMQ exchange that the seed URLs are published to
#   Default: 'govuk_crawler_exchange'
#
# [*amqp_host*]
#   The hostname of the RabbitMQ instance the seed URLs are published to
#   Default: ''
#
# [*amqp_pass*]
#   The password used to publish the seed URLs to RabbitMQ
#   Default: ''
#
# [*amqp_topic*]
#   The RabbitMQ topic that the seed URLs are published to
#   Default: '#'
#
# [*amqp_user*]
#   The username used to publish the seed URLs to RabbitMQ
#   Default: 'govuk_crawler_worker'
#
# [*amqp_vhost*]
#   The RabbitMQ virtual host that the seed URLs are published to
#   Default: '/'
#
# [*crawler_user*]
#   User that the synchronisation cron job runs as.
#   Default: 'govuk-crawler'
#
# [*mirror_root*]
#   The directory where crawled content is stored.
#   Mandatory parameter
#
# [*seed_enable*]
#   Whether to enable the cron job that seeds the crawler.
#   Default: false
#
# [*site_root*]
#   The web site to be crawled, e.g. https://www.gov.uk
#   Default: ''
#
# [*ssh_keys*]
#   A hash of hostnames with ssh host keys and type of ssh host key.
#   Default: {}
#
# [*ssh_private_key*]
#   SSH private key for the user that syncs crawled content to the
#   remote mirrors.
#   Default: ''
#
# [*sync_enable*]
#   Whether to enable the cron job that synchronises crawled content to the mirrors.
#   Default: false
#
# [*targets*]
#   An array of SSH user@host strings to sync the mirrored data to.
#   If populated then an Icinga passive check will be created.
#   If empty then no sync will be performed.
#   Default: []
#
class govuk_crawler(
  $amqp_exchange = 'govuk_crawler_exchange',
  $amqp_host = '',
  $amqp_pass = '',
  $amqp_topic = '#',
  $amqp_user = 'govuk_crawler_worker',
  $amqp_vhost = '/',
  $crawler_user = 'govuk-crawler',
  $mirror_root,
  $seed_enable = false,
  $site_root = '',
  $ssh_keys = {},
  $ssh_private_key = '',
  $sync_enable = false,
  $targets = [],
  $alert_hostname = 'alert.cluster',
) {
  include govuk_crawler::config

  validate_array($targets)
  validate_hash($ssh_keys)

  $seeder_script_name = 'seed-crawler'
  $seeder_script_args = "'${site_root}' --host '${amqp_host}' --username '${amqp_user}' --exchange '${amqp_exchange}' --topic '${amqp_topic}' --vhost '${amqp_vhost}'"
  $seeder_lock_path = "/var/run/${seeder_script_name}.lock"
  $seeder_script_path = "/usr/local/bin/${seeder_script_name}"
  $seeder_wrapper_name = "${seeder_script_name}-wrapper"
  $seeder_script_wrapper_path = "/usr/local/bin/${seeder_wrapper_name}"

  $sync_script_name = 'govuk_sync_mirror'
  $sync_lock_path = "/var/run/${sync_script_name}.lock"
  $sync_script_path = "/usr/local/bin/${sync_script_name}"
  $sync_error_dir = "${mirror_root}/error"

  # add ssh host keys of mirror targets.
  create_resources('sshkey', $ssh_keys)

  # User used to rsync crawled content to the remote mirror
  govuk_user { $crawler_user:
    fullname => 'GOV.UK Crawler',
    email    => 'webops@digital.cabinet-office.gov.uk',
  }
  file { "/home/${crawler_user}/.ssh/id_rsa":
    ensure  => file,
    owner   => $crawler_user,
    mode    => '0600',
    content => $ssh_private_key,
    require => Govuk_user[$crawler_user],
  }

  file { $seeder_lock_path:
    ensure => present,
    mode   => '0700',
    owner  => $crawler_user,
  }

  file { $sync_lock_path:
    ensure => present,
    mode   => '0700',
    owner  => $crawler_user,
  }

  package { 'govuk_seed_crawler':
        ensure   => '2.0.0',
        provider => system_gem,
  }

  # Needed to copy to AWS S3
  package { 's3cmd':
        ensure   => present,
        provider => pip,
  }

  $sync_service_desc = 'Mirror sync'
  $threshold_secs = 24 * (60 * 60)

  if !empty($targets) {
    @@icinga::passive_check { "check-mirror-sync-${::hostname}":
      service_description => $sync_service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
    }
  }

  # sync crawled content to remote mirror
  # relies on $sync_service_desc so must appear after in file
  file { $sync_script_path:
    ensure  => present,
    mode    => '0750',
    content => template("${module_name}/${sync_script_name}.erb"),
    owner   => $crawler_user,
  }

  $seed_ensure = $seed_enable ? {
    true    => present,
    default => absent,
  }

  # Needed for the wrapper script and also the icinga passive check.
  $seed_service_desc = 'seed_crawler last run status'

  # relies on $seed_service_desc so must appear after in file
  file { $seeder_script_wrapper_path:
    ensure  => present,
    mode    => '0750',
    owner   => $crawler_user,
    content => template("${module_name}/${seeder_wrapper_name}.erb"),
    require => File[$seeder_lock_path],
  }

  if ($seed_enable) {
    @@icinga::passive_check { "check_seed_crawler_${::hostname}":
      service_description => $seed_service_desc,
      host_name           => $::fqdn,
      # 90000 is slightly over 24 hours (86400)
      freshness_threshold => 90000,
    }
  }

  file { '/etc/cron.d/seed-crawler':
    ensure  => $seed_ensure,
    mode    => '0755',
    content => template('govuk_crawler/seed-crawler-wrapper-cron.erb'),
    require => [File[$seeder_script_wrapper_path], Package['daemontools']],
  }

  $sync_ensure = $sync_enable ? {
    true    => present,
    default => absent,
  }

  cron { 'sync-to-mirror':
    ensure      => $sync_ensure,
    user        => $crawler_user,
    minute      => '0',
    environment => 'MAILTO=""',
    command     => "/usr/bin/setlock -n ${sync_lock_path} ${sync_script_path}",
    require     => [File[$sync_error_dir], File[$sync_script_path], File[$sync_lock_path], Package['s3cmd'], Package['daemontools'], Class['govuk_crawler::config']],
  }

  file { $sync_error_dir:
    ensure => directory,
    mode   => '0755',
    owner  => $crawler_user,
  }

  collectd::plugin::file_count { 'mirror root':
    directory => $mirror_root,
  }
}
