# == Class: govuk::gor
#
# Setup gor traffic replay for GOV.UK
#
class govuk::gor(
  $enable_staging = false,
  $enable_plat1prod = false,
) {
  # Hardcoded, rather than hiera, because I don't want to create the
  # illusion that you can modify these on the fly. You will need to tidy
  # up old `host{}` records.
  $staging_ip     = '217.171.99.81'
  $staging_host   = 'www-origin-staging.production.alphagov.co.uk'
  $plat1prod_ip   = '37.26.90.220'
  $plat1prod_host = 'www-origin-plat1.production.alphagov.co.uk'

  if $enable_staging or $enable_plat1prod {
    $gor_hosts_ensure = present
  } else {
    $gor_hosts_ensure = absent
  }

  # FIXME: These "fake" host entries serve two purposes:
  #   1. Ensures that the SSL cert on staging, which thinks it is
  #   production, matches the hostname that we connect to.
  #   2. Prevents Gor/Go from performing DNS lookups, which occur once
  #   for *every* request/goroutine, and can be quite overwhelming.
  host {
    $staging_host:
      ensure  => $gor_hosts_ensure,
      ip      => $staging_ip,
      comment => 'Used by Gor. See comments in s_cache.';
    $plat1prod_host:
      ensure  => $gor_hosts_ensure,
      ip      => $plat1prod_ip,
      comment => 'Used by Gor. See comments in s_cache.';
  }
}
