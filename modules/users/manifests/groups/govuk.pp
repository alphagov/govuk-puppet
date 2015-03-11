# == Class: users::groups::govuk
#
# Install and configure SSH access for GDS staff
# Contractors should be defined in users::groups::contractors
#
class users::groups::govuk {

  ###################################################################
  #                                                                 #
  # When adding yourself to this list, please ensure that the list  #
  # remains sorted alphabetically by username and that the username #
  # is consistent with your LDAP username.                          #
  #                                                                 #
  ###################################################################

  include users::ajlanghorn
  include users::alex_tea
  include users::alexmuller
  include users::alext
  include users::alicebartlett
  include users::annashipman
  include users::benilovj
  include users::bob
  include users::bradleyw
  include users::carlmassa
  include users::chrisheathcote
  include users::danielroseman
  include users::davidsingleton
  include users::davidt
  include users::dcarley
  include users::eddsowden
  include users::heathd
  include users::henryhadlow
  include users::isabelllong
  include users::jabley
  include users::jackscotti
  include users::jacobashdown
  include users::james
  include users::jamiec
  include users::jennyduckett
  include users::kushalp
  include users::marksheldon
  include users::mattbostock
  include users::michaelpatrick
  include users::richardboulton
  include users::robyoung
  include users::rthorn
  include users::ssharpe
  include users::timothymower
  include users::tombooth
  include users::tombyers
  include users::tommypalmer
}
