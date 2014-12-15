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

  include users::aaronkeogh
  include users::ajlanghorn
  include users::alexmuller
  include users::alext
  include users::annashipman
  include users::benilovj
  include users::bob
  include users::bradleyw
  include users::carlmassa
  include users::dai
  include users::danielroseman
  include users::davidillsley
  include users::davidsingleton
  include users::davidt
  include users::dcarley
  include users::dominicbaggott
  include users::heathd
  include users::jabley
  include users::jacobashdown
  include users::james
  include users::jamiec
  include users::jennyduckett
  include users::jordan
  include users::kushalp
  include users::mattbostock
  include users::mwall
  include users::ppotter
  include users::psd
  include users::richardboulton
  include users::robyoung
  include users::roc
  include users::ssharpe
  include users::timothymower
  include users::tombooth

}
