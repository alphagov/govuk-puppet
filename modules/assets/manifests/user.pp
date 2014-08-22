# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class assets::user {
  group { 'assets':
    ensure => 'present',
    gid    => '2900',
  }

  user { 'assets':
    ensure  => 'present',
    home    => '/home/assets',
    shell   => '/bin/false',
    uid     => '2900',
    gid     => 'assets',
    require => [Group['assets']],
  }
}
