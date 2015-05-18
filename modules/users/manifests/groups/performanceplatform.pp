# == Class: users::groups::performanceplatform
#
# Install and configure SSH access for performance platform users
#
class users::groups::performanceplatform {

  ###################################################################
  #                                                                 #
  # When adding yourself to this list, please ensure that the list  #
  # remains sorted alphabetically by username and that the username #
  # is consistent with your LDAP username.                          #
  #                                                                 #
  ###################################################################

  include users::ppdeploy
}
