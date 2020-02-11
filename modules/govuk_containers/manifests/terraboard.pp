# == Class: govuk_containers::terraboard
#
# Install and run Terraboard in a Docker container with PostgreSQL backend
# and OAuth2 Proxy for authentication, also in Docker containers. All containers
# are connected to the `terranet` bridge network.
#
# The PostgreSQL database is used to cache Terraform states to reduce the amount
# of traffic.
#
# === Parameters
#
# [*aws_region*]
#   The AWS region to fetch Terraform state from.
#
# [*aws_access_key_id*]
#   The AWS access key ID to use when fetching Terraform state.
#
# [*aws_secret_access_key*]
#   The AWS secret access key to use when fetching Terraform state.
#
# [*aws_bucket*]
#   The AWS bucket to fetch the Terraform state from.
#
# [*db_password*]
#   The database password for the PostgreSQL Docker instance used by Terraboard.
#
# [*github_oauth_client_id*]
#   The OAuth client ID provided by GitHub for authentication.
#
# [*github_oauth_client_secret*]
#   The OAuth client secret provided by GitHub for authentication.
#
# [*oauth2_proxy_base_url*]
#   The base URL of the OAuth2 Proxy installation.
#
# [*oauth2_proxy_cookie_secret*]
#   A Base64-encoded secret used to encrypt the OAuth2 Proxy cookie.
#
class govuk_containers::terraboard(
  $aws_region = 'eu-west-1',
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_bucket = undef,
  $db_password = undef,
  $github_oauth_client_id = undef,
  $github_oauth_client_secret = undef,
  $oauth2_proxy_base_url = undef,
  $oauth2_proxy_cookie_secret = undef,
) {

  # These names come from the Terraboard defaults
  # GORM is an ORM for Golang
  $db_username = 'gorm'
  $db_name = 'gorm'

  # Only install Terraboard in AWS
  if $::aws_migration {
    $terraboard_ensure = absent
    $terraboard_directory = directory
  } else {
    $terraboard_ensure = absent
    $terraboard_directory = absent
  }

  file { ['/opt/terraboard', '/opt/terraboard/conf']:
    ensure => $terraboard_directory,
    mode   => '0700',
  }

  file { '/opt/terraboard/conf/oauth2_proxy.cfg':
    ensure  => $terraboard_ensure,
    mode    => '0600',
    content => template('govuk_containers/terraboard/conf/oauth2_proxy.cfg.erb'),
    require => File['/opt/terraboard/conf'],
  }

  docker_network { 'terranet':
    ensure => $terraboard_ensure,
  }

  ::docker::image { 'postgres':
    ensure    => $terraboard_ensure,
    require   => Class['govuk_docker'],
    image_tag => '10.5',
  }

  ::docker::run { 'terraboard-db':
    ensure  => $terraboard_ensure,
    net     => 'terranet',
    image   => 'postgres',
    require => [
      Docker::Image['postgres'],
      Docker_Network['terranet'],
    ],
    env     => [
      "POSTGRES_USER=${db_username}",
      "POSTGRES_DB=${db_name}",
      "POSTGRES_PASSWORD=${db_password}",
    ],
  }

  ::docker::image { 'camptocamp/terraboard':
    ensure    => $terraboard_ensure,
    require   => Class['govuk_docker'],
    image_tag => 'latest',
  }

  ::docker::run { 'terraboard':
    ensure  => $terraboard_ensure,
    net     => 'terranet',
    image   => 'camptocamp/terraboard',
    require => [
      Docker::Image['camptocamp/terraboard'],
      Docker_Network['terranet'],
    ],
    depends => 'terraboard-db',
    env     => [
      "AWS_REGION=${aws_region}",
      "AWS_ACCESS_KEY_ID=${aws_access_key_id}",
      "AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}",
      "AWS_BUCKET=${aws_bucket}",
      'DB_HOST=terraboard-db',
      "DB_PASSWORD=${db_password}",
    ],
  }

  ::docker::image { 'govuk/govuk-oauth2-proxy-docker':
    ensure    => $terraboard_ensure,
    require   => Class['govuk_docker'],
    image_tag => 'latest',
  }

  ::docker::run { 'terraboard-oauth2-proxy':
    ensure  => $terraboard_ensure,
    net     => 'terranet',
    image   => 'govuk/govuk-oauth2-proxy-docker',
    require => [
      Docker::Image['govuk/govuk-oauth2-proxy-docker'],
      Docker_Network['terranet'],
    ],
    ports   => ['7920:4180'],
    volumes => ['/opt/terraboard/conf:/conf'],
    depends => 'terraboard',
  }
}
