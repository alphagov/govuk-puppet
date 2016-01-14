# Creates the simonhughesdon user
class users::simonhughesdon {
  govuk::user { 'simonhughesdon':
    fullname => 'Simon Hughesdon',
    email    => 'simon.hughesdon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
