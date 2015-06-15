# == Class: users::groups::govuk_production_access {
#
# Configure SSH access to production environments for GDS staff
# and contractors who have been cleared to have production access.
#
# The process and policy for those requiring production access is listed at
# https://sites.google.com/a/digital.cabinet-office.gov.uk/gds-technology/production-access-and-support
#
# Define staff in users::groups::govuk, and contractors in
# users::groups::contractors.
#

class users::groups::govuk_production_access {

  include users::ajlanghorn
  include users::alexmuller
  include users::alext
  include users::annashipman
  include users::benilovj
  include users::bob
  include users::bradleyw
  include users::carlmassa
  include users::danielroseman
  include users::davidsingleton
  include users::dcarley
  include users::dominicbaggott
  include users::eddsowden
  include users::elliot
  include users::heathd
  include users::jabley
  include users::jacobashdown
  include users::james
  include users::jamiec
  include users::jennyduckett
  include users::joshmyers
  include users::kushalp
  include users::mattbostock
  include users::richardboulton
  include users::robyoung
  include users::ssharpe
  include users::timothymower
  include users::tombooth

}
