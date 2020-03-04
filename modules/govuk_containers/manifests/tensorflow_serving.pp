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
  $image_version = '2.0.0',
  $model_name = 'ltr'
) {

  ::docker::image { $image_name:
    ensure    => 'absent',
    require   => Class['govuk_docker'],
    image_tag => $image_version,
  }

  file { '/data/vhost/tensorflow-models':
    ensure  => absent,
    force   => true,
    recurse => true,
  }

  ::docker::run { 'tensorflow/serving':
    ensure           => 'absent',
    ports            => ['8501:8501'],
    image            => $image_name,
    require          => Docker::Image[$image_name],
    extra_parameters => ['-P', '-v', '/data/vhost/tensorflow-models:/models', "-e MODEL_NAME=${model_name}"],
  }
}
