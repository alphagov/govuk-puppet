# Creates the stevelaing user
class users::stevelaing {
  govuk::user { 'stevelaing':
    fullname => 'Steve Laing',
    email    => 'steve.laing@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCo2ah4oAUIuo2Btf335wcdTtapgTIX1V/+wpIf70kfRkPHjkIeWWvfAP5058EA9wpi7V6bwHZ195RJD8+UunepRys8XCLn0lJD+kwZoHejYpWu5px0pUNT+ULRX8zoyYEkMDHkvkorzFYafn/14WhmvlBX4wE3ehTdqhHzv1crVV5ua1DxT3kXIf9cYpuOJDpK+AVhv9D6SuIbZF/gi87anWSEZk7tjUN+7qnUDgUGDN1tdqhTbYvRAy01p4v5M6g5XLOk0WLW2KSnhe5ueLVv14HaV973ODPAq0yUGXyeyPnroryHkUx0XWrHLl4h5ziMJV4UDheB/g+EbRRXhSWd',
  }
}
