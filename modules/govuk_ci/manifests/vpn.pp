# == Class: govuk_ci::vpn
#
# Configure VPN on CI machines.
#
# === Parameters:
#
# [*ghe_vpn_username*]
#   The username used to connect to the Github Enterprise VPN
#
# [*ghe_vpn_password*]
#   The password to authenticate against the Github Enterprise VPN
#
class govuk_ci::vpn (
  $ghe_vpn_username,
  $ghe_vpn_password,
) {

  class { 'govuk_ghe_vpn':
    username => $ghe_vpn_username,
    password => $ghe_vpn_password,
  }

}

