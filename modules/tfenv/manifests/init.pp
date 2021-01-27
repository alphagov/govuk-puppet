# == Class: tfenv
#
class tfenv(
  $install_dir          = '/opt/tfenv',
  $tfenv_git_repo       = 'https://github.com/tfutils/tfenv',
  $tfenv_revision       = 'v2.0.0',
) {

  $packages = [
    git,
    unzip,
  ]

  ensure_packages($packages, {'ensure' => 'present'})

  file { $install_dir:
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
    require => Package[$packages],
  }
  -> vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    revision => $tfenv_revision,
    source   => $tfenv_git_repo,
    user     => 'jenkins',
    group    => 'jenkins',
  }

  file { '/usr/local/bin/tfenv':
    ensure  => link,
    target  => "${install_dir}/bin/tfenv",
    require => Vcsrepo[$install_dir],
  }

  file { '/usr/local/bin/terraform':
    ensure  => link,
    target  => "${install_dir}/bin/terraform",
    require => Vcsrepo[$install_dir],
  }

}
