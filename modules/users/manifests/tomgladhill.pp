# Create the tomgladhill user
class users::tomgladhill {
  govuk_user { 'tomgladhill':
    fullname => 'Tom Gladhill',
    email    => 'tom.gladhill@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfIL8ZPBMSZk4xvkAo6aAncMy2PWb9anitQS/itW+i3kaEnkDeyRquTNiD8L2SKYpSbPhbPeKGJ/sLre4SASMOzBOZu7IWPYkYCwKko1avDN/HNaTxPIIodJ3V+dQ9+Q1bweLKUCshPH76R81nmlo3nrGUZZ8jND4Inpfb6KAbVALLnYC23MvkUeYRgYQxsIzCjot87tubAt1cJsr2DPDODIX8haiEvbZmQTH3ZpEr7KgreT6V+yHaQxgi5N/IwIv2i8PHHJmeL7oBUwhxmavAU3Tp6I4wrXA4yq36Mpnec6GqGHw1R1Rw04TRPrNwlSZakF2l2ILD9k1fE9dcwhnFsUCBOToknNGwM6BpYGriwiGvdUbWewwkG4DiDAxrorSBv66f/CCUUE/pKXogbk2qs1SXgO9y7IpeXhbPsoS+cP3u/ok52dBXQftMq3vYXkXseDs/RZSHuhe4BW3k4xkkvnl3U40Pfy0rv9zgoQJOF0DlCOugPQLFqWBbeO4MPzFYL3L0b2hPxM9hfjCKjt+pVkq4bV/sLohC4t7eH3dVZQAubk4rACP9zenXDkFKSUYQf6PAR2oHlhKtuIjO3inM6EHnyJLfLpSbOevfVmtB/ThxdZ5RCMc+pAS636Eq+EQrmMIOBIcT9gGryP/TGV0vyNiJ6zWBtDYbybPeVE2bZw== tom.gladhill@digital.cabinet-office.gov.uk',
    ],
  }
}
