# Create the gideongoldberg user
class users::gideongoldberg {
  govuk_user { 'gideongoldberg':
    fullname => 'Gideon Goldberg',
    email    => 'gideon.goldberg@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDKiLCCTMW3GxprZmQVU1OQhoVi2Fp6CojL8cZ8bK1J1UBxyElg2kL4Ygs94iCvQMLdP80z7YT2v9DUJ9rxf4IQ9ipVYPBaS40uW+Wo19nNPUiO+u/bsYebvrkNmOJ5lxvvywCMudy7/k3lu/i2ejIyv4D4c8g++8JzpiqvSzu69PmMJv5OnuF2YJOKPw44PB0D3234P5/73Kfh21Xw0YQuI/WDXr3ZGnBFRUVkCmuHp9qxgfbU0g66ZkPb1qvaWdncXv/wcWLfh+ajlzIpldTBDWVJF+AxeGenQcpvM+wVaHkSGyTXZOICuV9ywXYedJy/Py+RoNDxRQcA4Yb5NDsbIUFFeN8ZbDf7YOC0c7vLOZkib5Mhfcodd0iuCW52jJvw7SnB0gPIvjFF9/HqYEAt1WOkw9oIqClrcfZhYSrevLxjFMr9rtzh9dx9RviKw9C4VhexlksI3OsTxzAnJ3Gn2Q2l7xb8b6oumHnAoIEGTkLPFYWGAoT35RS6zJWBg679sM4FhONEKrTmiqIBvNPr5y7jzEqPaHi1s1o2xzNYolsSRN0DKM5rUEUDAkL0a/fyrUsvwnx1B+VPsHoj0mJq+RmOEnvd69wB3Ifc7VnlMh6W926tMcMp7oQz6kKtVLmdzShOIiv1dyzJOXn+3kpAvzE2rvMFf6K+5g9HH5wdw== gideon.goldberg@digital.cabinet-office.gov.uk'
    ],
  }
}