# == Class: users::groups::newbamboo
#
# Configure SSH access to environments where New Bamboo staff require
# access.
#
class users::groups::newbamboo {

  include users::benp
  include users::niallm
  include users::ollyl

}
