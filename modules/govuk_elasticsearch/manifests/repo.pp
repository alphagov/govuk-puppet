# == Class: govuk_elasticsearch::repo
#
# Use our own mirror of the ES repo. Should be used with `manage_repo`
# disable of the upstream module.
#
# This *has* to be in a class otherwise there will be a dependency loop
# caused by a relationship between govuk_elasticsearch,
# govuk_java::oracle7::jdk, and apt::source.
#
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
# [*repo_version*]
#   The Version series to add the repo for (1.4 etc...)
#
class govuk_elasticsearch::repo(
  $apt_mirror_hostname = undef,
  $repo_version,
) {
  apt::source { "elasticsearch-${repo_version}":
    location     => "http://${apt_mirror_hostname}/elasticsearch-${repo_version}",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }
}
