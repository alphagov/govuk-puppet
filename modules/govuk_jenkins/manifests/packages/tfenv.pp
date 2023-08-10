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
  $terraform_versions = ['0.11.15', '0.12.30', '0.12.31', '0.13.6', '1.1.5', '1.1.7', '1.4.1', '1.4.6', '1.5.4'],
){

  include ::tfenv
  ::tfenv::terraform { $terraform_versions: }

}
