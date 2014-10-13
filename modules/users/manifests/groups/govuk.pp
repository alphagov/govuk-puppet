# == Class: users::groups::govuk
#
# Install and configure SSH access for GDS staff
# Contractors should be defined in users::groups::contractors
#
class users::groups::govuk {

  ###################################################################
  #                                                                 #
  # When adding yourself to this list, please ensure that the list  #
  # remains sorted alphabetically by username.                      #
  #                                                                 #
  ###################################################################

  include users::aaronkeogh
  include users::ajlanghorn
  include users::alex_tea
  include users::alexmuller
  include users::alext
  include users::alicebartlett
  include users::amywhitney
  include users::annashipman
  include users::benilovj
  include users::bob
  include users::bradleyw
  include users::carlmassa
  include users::chrisheathcote
  include users::dai
  include users::danielroseman
  include users::davidillsley
  include users::davidsingleton
  include users::davidt
  include users::dcarley
  include users::eddsowden
  include users::heathd
  include users::henryhadlow
  include users::isabelllong
  include users::jabley
  include users::jacobashdown
  include users::james
  include users::jamiec
  include users::jennyduckett
  include users::jordan
  include users::kushalp
  include users::mattbostock
  include users::minglis
  include users::mwall
  include users::ppotter
  include users::psd
  include users::richardboulton
  include users::robyoung
  include users::roc
  include users::rthorn
  include users::ssharpe
  include users::timpaul
  include users::timothymower
  include users::tombooth
  include users::tombyers
  include users::tommypalmer
}
