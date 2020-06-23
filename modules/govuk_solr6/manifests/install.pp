# == Class: govuk_solr::install
#
# Installs the solr package
#
class govuk_solr6::install (
  $version  = '6.4.2',
  $base_url = 'https://archive.apache.org/dist/lucene/solr/',
  $solr_install_dir = undef,
  $solr_home = undef,
  $solr_user = undef,
) {

  $solr_install_dir_parent = dirname($solr_install_dir)

  user { $solr_user:
    ensure     => present,
    home       => $solr_home,
    managehome => true,
    shell      => '/bin/bash',
  }

  file { $solr_home:
    ensure  => 'directory',
    owner   => $solr_user,
    group   => $solr_user,
    require => User[$solr_user],
  }

  file { $solr_install_dir_parent:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  archive { 'solr':
    ensure       => present,
    path         => '/tmp/solr.tgz',
    extract      => true,
    source       => "${base_url}${version}/solr-${version}.tgz",
    extract_path => $solr_install_dir_parent,
    require      => File[$solr_install_dir_parent],
    cleanup      => true,
    user         => $solr_user,
    group        => $solr_user,
    creates      => "${solr_install_dir_parent}/solr-${version}/LICENSE.txt",
  }

  file { $solr_install_dir:
    ensure  => 'link',
    target  => "${solr_install_dir_parent}/solr-${version}",
    require => Archive['solr'],
  }
}
