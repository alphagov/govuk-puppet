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
    package_ensure => '0.6',
    config         => {
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
      key      => '2A194991';
    'puppetlabs-precise':
      location => 'http://apt.puppetlabs.com/',
      repos    => ['main', 'dependencies'],
      release  => 'precise',
      key      => '4BD6EC30';
    'puppetlabs-trusty':
      location => 'http://apt.puppetlabs.com/',
      repos    => ['main', 'dependencies'],
      release  => 'trusty',
      key      => '4BD6EC30';
    'govuk-ppa-precise':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'precise',
      key      => '914D5813';
    'govuk-ppa-trusty':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'trusty',
      key      => '914D5813';
    'elasticsearch-0.90':
      location => 'http://packages.elasticsearch.org/elasticsearch/0.90/debian',
      release  => 'stable',
      key      => 'D88E42B4';
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
      release  => 'main',
      key      => '418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB';
    'rabbitmq':
      location => 'http://www.rabbitmq.com/debian',
      release  => 'testing',
      key      => '056E8E56';
    'mongodb':
      location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      release  => 'dist',
      key      => '7F0CEB10';
    'jenkins':
      location => 'http://pkg.jenkins-ci.org/debian-stable',
      release  => 'binary/', # Trailing slash is significant.
      key      => 'D50582E6';
    'percona':
      location => 'http://repo.percona.com/apt',
      release  => 'trusty',
      key      => '1C4CBDCDCD2EFD2A';
  }
  aptly::repo { 'gof3r': }
  aptly::repo { 'govuk-jenkins': }
  aptly::repo { 'terraform': }

  include nginx
  nginx::config::site { 'apt.cluster':
    content => template('govuk/node/s_apt/vhost.conf.erb'),
  }

}
