# Creates the theodorvararu user
class users::theodorvararu {
  govuk_user { 'theodorvararu':
    fullname => 'Theodor Vararu',
    email    => 'theodor.vararu@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgcHJYq+SqN+9xoXl8aRtVO/JTb2I2ORPRsauEy4fnTpnCLXDO8wsg6cHpn6w3wCoB9yeZ2plEnClKPvLp8Q+/TJC4QR3XU6fgdUtOGTV+7eLPSqzP/xOjd8EVBod+4Mm+1vDozc6jjS518MkWcuQIXjZi/MX2BrqqBD0DHmEodpVKNlE+pZyVL8Snx/AILfIRAOujx4qjZmQC6ceCKvguBIjQp8G86xq48PR2O3V6OBwrcCtj0dEV/Pbi0Kl+qbTOWI4sgwRLx1sdgkjT4qEgTsIpahchACCQXoQZiRLpYLRfPMvJV9RjyLRKngHa5iyCTXy3BPOzh0SrHpUom0V3 theodor.vararu@digital.cabinet-office.gov.uk',
  }
}
