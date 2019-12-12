# == Class: govuk_containers::tensorflow_serving
#
# Install and run a dockerised Tensorflow server
#
# === Parameters
#
# [*image_name*]
#   Docker image name to use for the container.
#
# [*image_version*]
#   The docker image version to use.
#
class govuk_containers::tensorflow_serving(
  $image_name = 'tensorflow/serving',
  $image_version = 'latest',
  $model_name = 'ltr'
) {

  ::docker::image { $image_name:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $image_version,
  }

  file { '/data/vhost/tensorflow-models':
    ensure => directory,
  } ->

  ::docker::run { 'tensorflow/serving':
    ports            => ['8501:8501'],
    image            => $image_name,
    require          => Docker::Image[$image_name],
    extra_parameters => ['-P', '-v', '/data/vhost/tensorflow-models:/models', "-e MODEL_NAME=${model_name}"],
  }

  @@icinga::check { "check_tensorflow_serving_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!tensorflow_mode',
    service_description => 'Tensorflow Serving running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}
