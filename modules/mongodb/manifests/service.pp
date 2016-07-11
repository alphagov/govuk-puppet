# == Class: Mongodb::Service
#
# Manages the MongoDB service
#
# === Parameters
#
# [*service_name*]
# Name of the MongoDB service. In 2.x, this is 'mongodb', and in 3.x this is
# 'mongod'.
#
class mongodb::service (
  $service_name = 'mongodb',
) {

  service { $service_name:
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

}
