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
  include users::amywhitney
  include users::annashipman
  include users::bob
  include users::bradleyw
  include users::carlmassa
  include users::chrisheathcote
  include users::dai
  include users::davidillsley
  include users::davidt
  include users::dcarley
  include users::eddsowden
  include users::edhorsford
  include users::garethr
  include users::heathd
  include users::henryhadlow
  include users::jabley
  include users::james
  include users::jamiec
  include users::jennyduckett
  include users::jordan
  include users::joshua
  include users::kushalp
  include users::mazz
  include users::minglis
  include users::mwall
  include users::nick
  include users::norm
  include users::ops01
  include users::ops02
  include users::ops04
  include users::ppotter
  include users::psd
  include users::robyoung
  include users::roc
  include users::ssharpe
  include users::timpaul
  include users::tombooth
  include users::tombyers
}
