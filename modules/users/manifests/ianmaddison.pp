# Creates the ianmaddison user
class users::ianmaddison {
  govuk_user { 'ianmaddison':
    fullname => 'Ian Maddison',
    email    => 'ian.maddison@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJQqiPkck31aFdX0m97M3LhLuJ8+WULi8Au2n1vLg01jW+heTFKTIWiDod/a0VNs0huq3AbCdy2LAY7xSegHqCz3i2WXNFbAOOxtcmSRduiuCEgFsIQCutAfUcEEOqesF1oFE2k6zL3HjXwleqgbsaFgfq8MTvshwUI8olhmqMcXORVE67YaKgj5Ysn4MnsKMMYDllmKytKSDcLwqM002uCcPaU4/VgF6qAjFJquPm73W86GGhmjOBgNVsI5fmmCcj9opD+34/a1RlgonMBTyK9L1TQ4Y8UMiIx73JGuM/opw9GeYopGaJwdryCBgwkgXlCFSatVtGxBcsBjOh9Yx1T04gO9oUS1zRvb2HxKtc4zp0JeCElftuuEpTDkdygycU0YcPmcScIK1Ha4PHiowJrkA0nlu/Pnmj+pB9fXqnuBOg30OpT56f/i+dRfU4MTPkhjtvoerme5/RPFXpOksV/200r5a1foPeY6QvcQP+HSK0AD9cSJ/GLwokvKfYeiHSX3ZUti9FIrZejT+NslSthbUdfkMs7GT45SmpHF8b4oWcLMqqGoHunysl1mcLsdPkBuDfKDgB2BcYHUvCqPmlMEtwF02319pbjFSoJl+9iYMF8TJRFBKDzTKsQ4ffJ05EbQLYQFJvAx9g5YBwzb2WdRND8fjPfrcHfHc0bFE4jw== ian.maddison@digital.cabinet-office.gov.uk',
  }
}
