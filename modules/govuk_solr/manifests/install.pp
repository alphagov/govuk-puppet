# == Class: govuk_solr::install
#
# Installs the solr package
#
# === Parameters
#
# [*version*]
#   The version of solr to install
#
# [*base_url*]
#   The mirror to fetch the solr archive from
#
class govuk_solr::install (
  $version  = '4.3.1',
  $base_url = 'https://archive.apache.org/dist/lucene/solr/',
  $remove = undef,
) {

  $ensure_user = $remove ? {
    false => present,
    true  => absent,
  }

  $ensure_dir = $remove ? {
    false => directory,
    true  => absent,
  }

  $ensure_archive = $remove ? {
    false => present,
    true  => absent,
  }

  $ensure_link = $remove ? {
    false => link,
    true  => absent,
  }

  user { 'solr':
    ensure     => $ensure_user,
    home       => '/var/lib/solr',
    managehome => true,
    shell      => '/bin/bash',
  }

  file { '/var/lib/solr':
    ensure  => $ensure_dir,
    owner   => 'solr',
    group   => 'solr',
    require => User['solr'],
  }

  archive { 'solr':
    ensure       => $ensure_archive,
    path         => '/tmp/solr.tgz',
    extract      => true,
    source       => "${base_url}${version}/solr-${version}.tgz",
    extract_path => '/var/lib/solr',
    require      => File['/var/lib/solr'],
    cleanup      => true,
    user         => 'solr',
    group        => 'solr',
    creates      => "/var/lib/solr/solr-${version}/LICENSE.txt",
  }

  file { '/var/lib/solr/current':
    ensure  => $ensure_link,
    target  => "/var/lib/solr/solr-${version}",
    require => Archive['solr'],
  }
}
