# == Class: users::groups::contractors
#
# Contractors working at GDS should be added to this list.
# Please ensure that the list remains sorted alphabetically by username
# and that the username is consistent with your LDAP username.
#
class users::groups::contractors {
  include users::benjanecke
  include users::dominicbaggott
  include users::elliot
  include users::futurefabric
  include users::paulhayes
  include users::tadast
  include users::tekin
  include users::vinayvinay
}
