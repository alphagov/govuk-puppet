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
class elasticsearch {
  include elasticsearch::package
  include elasticsearch::config
  include elasticsearch::service
}
