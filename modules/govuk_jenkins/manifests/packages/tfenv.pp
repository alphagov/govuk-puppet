# == Class: govuk_jenkins::packages::tfenv
#
# Installs tfenv https://github.com/tfutils/tfenv
# to manage multiple versions of terraform installed concurrently on the system
#
# === Parameters
#
# [*terraform_versions*]
#   The list of terraform versions to be installed
#
#
class govuk_jenkins::packages::tfenv (
  $terraform_versions = ['0.11.14', '0.11.15', '0.12.30', '0.13.6'],
){

  include ::tfenv
  ::tfenv::terraform { $terraform_versions: }

}
