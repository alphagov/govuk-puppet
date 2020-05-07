# This node exists in production to serve all other environments. So that we:
#
#   - can maintain/promote consistent snapshots across all environments
#   - don't duplicate storage in each environment
#   - have something that we can point Vagrant and smaller environments to
#
# [*private_gpg_key*]
#   The private key to sign the repos with
#
# [*private_gpg_key_fingerprint*]
#   The fingerprint is required to specify the private key.
#
class govuk::node::s_apt (
  $root_dir,
  $private_gpg_key = undef,
  $private_gpg_key_fingerprint = undef,
  $real_ip_header = undef,
  $apt_service = 'apt.cluster',
  $gemstash_service = 'gemstash.cluster',
) inherits govuk::node::s_base {

  # Only mirror our current arch to save space. This means that some
  # `apt::source` resources will need to specify an `architecture` param to
  # select only "amd64" or "binary".
  class { 'aptly':
    config => {
      'rootDir'       => $root_dir,
      'architectures' => [$::architecture],
    },
  }

  Govuk_mount[$root_dir] -> Class['aptly']

  file { $root_dir:
    ensure  => directory,
    owner   => 'deploy',
    group   => 'root',
    mode    => '0775',
    purge   => false,
    require => User['deploy'],
  }

  aptly::mirror {
    'aptly':
      location => 'http://repo.aptly.info',
      release  => 'squeeze',
      key      => 'ED75B5A4483DA07C';
    'duplicity':
      location => 'http://ppa.launchpad.net/duplicity-team/ppa/ubuntu',
      release  => 'trusty',
      key      => 'AF953139C1DF9EF3476DE1D58F571BB27A86F4A2';
    'docker':
      location => 'https://download.docker.com/linux/ubuntu',
      release  => 'trusty',
      repos    => ['stable'],
      key      => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88';
    'govuk-ppa-trusty':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'trusty',
      key      => '914D5813';
    'grafana':
      location => 'https://packagecloud.io/grafana/stable/debian',
      release  => 'jessie',
      key      => '418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB';
    'mongodb':
      location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      release  => 'dist',
      key      => '7F0CEB10';
    'mongodb3.2':
      location => 'https://repo.mongodb.org/apt/ubuntu',
      release  => 'trusty/mongodb-org/3.2',
      key      => 'EA312927';
    'mongodb3.6':
        location => 'https://repo.mongodb.org/apt/ubuntu',
        release  => 'trusty/mongodb-org/3.6',
        key      => '91FA4AD5';
    'nginx':
      location => 'https://nginx.org/packages/ubuntu/',
      release  => 'trusty',
      key      => 'ABF5BD827BD9BF62';
    'nodejs':
      location => 'https://deb.nodesource.com/node_6.x',
      release  => 'trusty',
      repos    => ['main'],
      key      => '68576280';
    'openjdk':
      location => 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu/',
      release  => 'trusty',
      key      => 'DA1A4A13543B466853BAF164EB9B1D8886F44E2A';
    'percona':
      location => 'http://repo.percona.com/apt',
      release  => 'trusty',
      key      => '8507EFA5';
    'postgresql':
      location => 'http://apt.postgresql.org/pub/repos/apt/',
      release  => 'trusty-pgdg',
      key      => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8';
    'puppetlabs-trusty':
      location => 'http://apt.puppetlabs.com/',
      repos    => ['main', 'dependencies'],
      release  => 'trusty',
      key      => 'EF8D349F';
    'puppetlabs-xenial':
      location => 'http://apt.puppetlabs.com/',
      repos    => ['PC1'],
      release  => 'xenial',
      key      => 'EF8D349F';
    'rabbitmq':
      location => 'http://www.rabbitmq.com/debian',
      release  => 'testing',
      key      => '6026DFCA';
    'sysdig':
      location => 'http://download.draios.com/stable/deb',
      release  => 'stable-amd64/',
      key      => 'D27A72F32D867DF9300A241574490FD6EC51E8C4';
    'yarn':
      location => 'https://dl.yarnpkg.com/debian/',
      release  => 'stable',
      repos    => ['main'],
      key      => '72ECF46A56B4AD39C907BBB71646B01B86E50310';
  }

  aptly::repo { 'awscli': }
  aptly::repo { 'collectd': }
  aptly::repo { 'awscloudwatch': }
  aptly::repo { 'elastic-beats': }
  aptly::repo { 'etcdctl': }
  aptly::repo { 'govuk-gatling': }
  aptly::repo { 'gdal': }
  aptly::repo { 'gof3r': }
  aptly::repo { 'google-cloud-sdk-trusty': }
  aptly::repo { 'gor': }
  aptly::repo { 'govuk-jenkins': }
  aptly::repo { 'govuk-mongo': }
  aptly::repo { 'govuk-prometheus': }
  aptly::repo { 'govuk-prometheus-node-exporter': }
  aptly::repo { 'govuk-python': }
  aptly::repo { 'govuk-rubygems': }
  aptly::repo { 'govuk-splunk-configurator': }
  aptly::repo { 'jenkins-agent': }
  aptly::repo { 'locksmithctl': }
  aptly::repo { 'logstash': }
  aptly::repo { 'rbenv-ruby': }
  aptly::repo { 'rbenv-ruby-xenial':
    distribution => 'xenial',
  }
  aptly::repo { 'sops': }
  aptly::repo { 'splunk': }
  aptly::repo { 'statsd': }
  aptly::repo { 'terraform': }
  aptly::repo { 'whisper-backup': }

  include nginx
  nginx::config::site { $apt_service:
    content => template('govuk/node/s_apt/apt_cluster_vhost.conf.erb'),
  }
  nginx::config::site { $gemstash_service:
    content => template('govuk/node/s_apt/gemstash_cluster_vhost.conf.erb'),
  }

  # Manage our local Gemstash mirror. Deployed via a docker container
  include ::govuk_docker
  include ::govuk_containers::gemstash

  if $private_gpg_key {
    file { "/root/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc":
      ensure  => present,
      mode    => '0600',
      content => $private_gpg_key,
      owner   => 'root',
      group   => 'root',
    }

    exec { "import_gpg_secret_key_for_aptly_${::hostname}":
      command     => "gpg --batch --delete-secret-and-public-key ${private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /root/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc",
      user        => 'root',
      group       => 'root',
      subscribe   => File["/root/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc"],
      refreshonly => true,
    }
  }
}
