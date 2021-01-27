# == Define: tfenv::terraform
#
define tfenv::terraform (
  $version = $title,
) {
  if ! defined(Class['tfenv']) {
    fail('You must include the tfenv base class before using any tfenv defined resources')
  }

  $install_path = $::tfenv::install_dir

  exec { "Install terraform version ${version}":
    command => "tfenv install ${version}",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "test -d ${install_path}/versions/${version}",
  }
}
