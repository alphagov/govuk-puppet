# == Define: govuk::app::envvar::rabbitmq
#
# Defines RabbitMQ env vars for an app.
#
# === Parameters
#
# [*hosts*]
#   Array of RabbitMQ server names.
#
# [*user*]
#   The RabbitMQ username.
#
# [*password*]
#   The RabbitMQ password.
#
# [*vhost*]
#   The RabbitMQ vhost.
#   Default: "/"
#
# [*url*]
#   URL of the RabbitMQ broker, including username and password
#   Default: ""
# 
define govuk::app::envvar::rabbitmq (
  $hosts,
  $user,
  $password,
  $vhost = '/',
  $url = '',
) {

  validate_array($hosts)
  if ($hosts == []) {
    fail 'must pass hosts'
  }

  Govuk::App::Envvar {
    app => $title,
  }

  govuk::app::envvar {
    "${title}-RABBITMQ_HOSTS":
      varname => 'RABBITMQ_HOSTS',
      value   => join($hosts, ',');
    "${title}-RABBITMQ_VHOST":
      varname => 'RABBITMQ_VHOST',
      value   => $vhost;
    "${title}-RABBITMQ_USER":
      varname => 'RABBITMQ_USER',
      value   => $user;
    "${title}-RABBITMQ_PASSWORD":
      varname => 'RABBITMQ_PASSWORD',
      value   => $password;
    "${title}-RABBITMQ_URL":
      varname => 'RABBITMQ_URL',
      value   => $url;
  }
}
