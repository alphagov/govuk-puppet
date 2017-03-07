# This node exists in production to serve all other environments. So that we:
#
#   - can maintain/promote consistent snapshots across all environments
#   - don't duplicate storage in each environment
#   - have something that we can point Vagrant and smaller environments to
#
class govuk::node::s_apt (
  $root_dir,
  $real_ip_header = undef,
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
      key      => '9E3E53F19C7DE460';
    'puppetlabs-precise':
      location => 'http://apt.puppetlabs.com/',
      repos    => ['main', 'dependencies'],
      release  => 'precise',
      key      => 'EF8D349F';
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
    'govuk-ppa-precise':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'precise',
      key      => '914D5813';
    'govuk-ppa-trusty':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'trusty',
      key      => '914D5813';
    'elasticsearch-1.4':
      location => 'http://packages.elasticsearch.org/elasticsearch/1.4/debian',
      release  => 'stable',
      key      => 'D88E42B4';
    'elasticsearch-1.5':
      location => 'http://packages.elastic.co/elasticsearch/1.5/debian',
      release  => 'stable',
      key      => '46095ACC8548582C1A2699A9D27D666CD88E42B4';
    'elasticsearch-1.7':
      location => 'http://packages.elastic.co/elasticsearch/1.7/debian',
      release  => 'stable',
      key      => '46095ACC8548582C1A2699A9D27D666CD88E42B4';
    'grafana':
      location => 'https://packagecloud.io/grafana/stable/debian',
      release  => 'jessie',
      key      => '418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB';
    'rabbitmq':
      location => 'http://www.rabbitmq.com/debian',
      release  => 'testing',
      key      => '6026DFCA';
    'mongodb':
      location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      release  => 'dist',
      key      => '7F0CEB10';
    'mongodb3.2':
      location => 'https://repo.mongodb.org/apt/ubuntu',
      release  => 'trusty/mongodb-org/3.2',
      key      => 'EA312927';
    'percona':
      location => 'http://repo.percona.com/apt',
      release  => 'trusty',
      key      => '8507EFA5';
    'postgresql':
      location => 'http://apt.postgresql.org/pub/repos/apt/',
      release  => 'trusty-pgdg',
      key      => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8';
    'sysdig':
      location => 'http://download.draios.com/stable/deb',
      release  => 'stable-amd64/',
      key      => 'D27A72F32D867DF9300A241574490FD6EC51E8C4';
    'duplicity':
      location => 'http://ppa.launchpad.net/duplicity-team/ppa/ubuntu',
      release  => 'trusty',
      key      => 'AF953139C1DF9EF3476DE1D58F571BB27A86F4A2';
  }

  aptly::repo { 'elastic-beats': }
  aptly::repo { 'gof3r': }
  aptly::repo { 'gor': }
  aptly::repo { 'govuk-jenkins': }
  aptly::repo { 'govuk-rubygems': }
  aptly::repo { 'jenkins-agent': }
  aptly::repo { 'locksmithctl': }
  aptly::repo { 'rbenv-ruby': }
  aptly::repo { 'rbenv-ruby-xenial':
    distribution => 'xenial',
  }
  aptly::repo { 'statsd': }
  aptly::repo { 'terraform': }

  include nginx
  nginx::config::site { 'apt.cluster':
    content => template('govuk/node/s_apt/vhost.conf.erb'),
  }

}
