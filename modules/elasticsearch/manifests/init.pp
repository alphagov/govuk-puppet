# Class: elasticsearch
#
# This is a module for managing a single node elasticsearch instance.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# class default {
#   include elasticsearch
# }
#
class elasticsearch($cluster) {
  include elasticsearch::package
  class { 'elasticsearch::config':
    cluster => $cluster
  }
  include elasticsearch::config
  include elasticsearch::service
}
