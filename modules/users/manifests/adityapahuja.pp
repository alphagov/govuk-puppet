# Creates the user adityapahuja for Aditya Pahuja
class users::adityapahuja {
  govuk_user { 'adityapahuja':
    ensure   => absent,
    fullname => 'Aditya Pahuja',
    email    => 'aditya.pahuja@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+tFGISKZorFgNeSGCicgsZYHuSEe/MYNs7iYqMfTgH286kM05oNt2FrgS9mIzOptJj9AndZeBqrWwTsJcBAyfI0dj2R490aX48AUDuQdZVYs793zjn0A6clh/3BucuEwkOVFr+UEMKJGeDM471QxfJ4+TK4uxGG4Ep0o7cLgSHcfjOiz9eCkBdoqDxZ4dC1J0IbVuhHNCG31bkOGoCpuDLFpDxLcyB7Q23C279nZiGhIiYrgELJ/VkyFWua/8SBQ+kxk7XzSznlKvR+X1Sh41V4VatUnOEJvIavwGkNcxX8PzPrj7YghG/dDRMd9iELRgQFauP22CaSy5z8QPTswGE+tS3z+yQ79RosJOiR/fVwwGq9RN9WdnUX6K5esZmACwIdZucqTlS/LtiM5WTWqGqwSRVc3r5U514l1fGwAZdRrpj13NuLHiwq5Nb5eOg0m6na8uoGCMfmsNSPNM59ApWyXeXRcnCwyJLMPj3A1sZU5Mmp+YIWjmA2QuIP7qzl28xHzb9uSaRMsn4LccfPiXTUReqGyLueOwcePRZQf1uMi+6BT3nFOJUhQQQX/8lZX28xTPj1UVpzSWAmEgvHvEsQdjG4lWPOqVFJWUkIPTZQ1UFr4gVWrBCYloFTm683723jJrfllXFJ348yANZS8EH5d5YP/AhrSVoEjWXyRF3Q== adityapahuja@gds3884.local',
    ],
  }
}
