# == Define: govuk_rbenv::install_ruby_version
#
# Installs a version of Ruby passed in as the name value. This define was
# wrote as a means to get around the lack of explicit loop support in Puppet 3
# and is thus a bit of a hack - if it transpires that we need to support
# different gem versions for different rubies this could be a problem but this
# hasn't been the case for years on GOV.UK
#
# === Parameters
#
# [*with_foreman*]
#   Whether to install the foreman gem on the system
#
define govuk_rbenv::install_ruby_version(
  $with_foreman = false,
) {
  rbenv::version { $name:
    bundler_version  => '1.16.2',
    install_gem_docs => false,
  }

  if $with_foreman {
    $foreman_version = '0.85'
    $gem_cmd = "${rbenv::params::rbenv_binary} exec gem"
    exec { "install foreman for ruby ${name}":
      command     => "${gem_cmd} install foreman -v ${foreman_version}",
      unless      => "${gem_cmd} query -i -n foreman -v ${foreman_version}",
      environment => [
        "RBENV_ROOT=${rbenv::params::rbenv_root}",
        "RBENV_VERSION=${name}",
      ],
      notify      => Rbenv::Rehash[$name],
    }
  }
}
