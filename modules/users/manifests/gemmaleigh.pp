# Creates the gemmaleigh user
class users::gemmaleigh {
  govuk::user { 'gemmaleigh':
    fullname => 'Gemma Leigh',
    email    => 'gemma.leigh@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDh5bpMs3odjiGgV0ObV9A8Bk+8zir0XLuXDOq+SA0+Zqc9X9F5nyDvjxh2XERHM6EX6SKYdVWLmpeBgQRvQgg8/mszNcZ6/JgsV3PTb2ULPWwzFjpEeY/8kA6hgu0qxynQ+e34dU1tk52c3e+vPK88uiOKwAOCue7nUUf3Y6ANy73lecs3OpVGc3mYNwiAr1xpr8GIozi35FaMx/fk2Q2TiO90dGl8QNi03Tpj4MwMP5q72/Qp+Tgk5LNfsECj4OCH2DNBfSzVv+FUh2E0QJHHW8oznikxj7bWd15EEr83+ya0qIkwePJQW5RzzzEs5SGmCYnRYWwzblO6Xpxmeg5P gemma.leigh@digital.cabinet-office.gov.uk',
  }
}
