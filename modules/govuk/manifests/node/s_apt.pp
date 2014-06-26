# This node exists in production to serve all other environments. So that we:
#
#   - can maintain/promote consistent snapshots across all environments
#   - don't duplicate storage in each environment
#   - have something that we can point Vagrant and smaller environments to
#
class govuk::node::s_apt (
  $root_dir
) inherits govuk::node::s_base {

  # Only mirror our current arch to save space. This means that some
  # `apt::source` resources will need to specify an `architecture` param to
  # select only "amd64" or "binary".
  class { 'aptly':
    config            => {
      'rootDir'       => $root_dir,
      'architectures' => [$::architecture],
    },
  }

  #FIXME: remove if when we have moved to platform one
  if hiera(use_hiera_disks,false) {
    Govuk::Mount[$root_dir] -> Class['aptly']
  }

  aptly::mirror {
    'aptly':
      location => 'http://repo.aptly.info',
      release  => 'squeeze',
      key      => '2A194991';
    'puppetlabs':
      location => 'http://apt.puppetlabs.com/',
      repos    => ['main', 'dependencies'],
      release  => 'stable',
      key      => '4BD6EC30';
    'govuk-ppa-precise':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'precise',
      key      => '914D5813';
    'govuk-ppa-lucid':
      location => 'http://ppa.launchpad.net/gds/govuk/ubuntu',
      release  => 'lucid',
      key      => '914D5813';
    'elasticsearch-0.90':
      location => 'http://packages.elasticsearch.org/elasticsearch/0.90/debian',
      release  => 'stable',
      key      => 'D88E42B4';
    'rabbitmq':
      location => 'http://www.rabbitmq.com/debian',
      release  => 'testing',
      key      => '056E8E56';
  }

  include nginx
  nginx::config::site { 'apt.cluster':
    content => template('govuk/node/s_apt/vhost.conf.erb'),
  }

}
