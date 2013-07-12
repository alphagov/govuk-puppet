# = Class: router::fco_services
#
# Configure vhost for serving FCO payment services hosted on *.service.gov.uk
#
class router::fco_services {

  router::fco_services::service {
    [
      'pay-legalisation-post',
      'pay-legalisation-drop-off',
      'deposit-foreign-marriage',
      'pay-foreign-marriage-certificates',
      'pay-register-death-abroad',
      'pay-register-birth-abroad',
    ]:
  }

}
