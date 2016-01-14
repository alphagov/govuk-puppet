# Creates the marksheldon user
class users::marksheldon {
  govuk::user { 'marksheldon':
    fullname => 'Mark Sheldon',
    email    => 'mark.sheldon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
