class users::alext {
  govuk::user { 'alext':
    fullname => 'Alex Tomlins',
    email    => 'alex.tomlins@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDEgfmhnlrUBF5i39bRssSJDaPvSxOn+cGUv2W+nliyExgbzxjIjE/qsbzPONyp1S1eBj2//EdLXR0ywzafNtLYG20dETF4RYGrULzww7RdX9KoJoLcujQy/T2+EbjcbuA+WXe9NLARSod3Sba+udFxV9uoVcVvHl659aVIKOe0I4iiu14XySn46NEXwmoL904bdqqc4FyBAYD1ch0uk2O5233TEwC32tQ4EENLTRsClYIGy2Pnq0h0gI8F031JMSuzYuum9CR4F1BkrrOJ+t7RJAy6rp8wuSrZM9Y6VLwMRHDbGStq3mNBZK4f7ZsIcaJwaCv2rtLYoZEmEjSQNVeP',
  }
  ssh_authorized_key { "alext_anduril_key":
    ensure => present,
    key    => 'AAAAB3NzaC1kc3MAAACBAPir8fE17By0A0AfN/WfY5JWJq7K24lt7jyZVQ2lk+ka9M2RnuioClS/441h4H0f185Sm9ZtA/JBElGUcO3YQ3brCqZrsk5dI18KYknMV5HTEpOWDugPXO6B6YtDKHgZGhSRLCfOYZJUxYkgt1jbzMLbMXNyx+b5ZGpehtfYQ41jAAAAFQCH/Pli07g5PbAq2gtCSGjhUHHWzQAAAIEA6jATflWdoHAjL/UZzJjRK+vf7nO5dNrNRN80VtX/7kmCTq4jHpRdTlA7QzBkSZNCOyZyAfPr9SDBrg0Iqz3de6j9E13wD2Yt61m0XRK5RODHuBSMTg/ebL54Fjb2ATiPtlDITtZ+JoWZXmhncBXedKjlkL3dslBne5vN0BSJp0QAAACAYqcrE3h/YkSrDehf91rIWe8zxJaDWyDGCtS+FyjB17mQFpcSW6TTLylnvqd9BEIsXIwRbj1tJcao1J35dnYO6iC6qqIKfW8geD+nIzb0tcYnTVNF3Kkqnn+isJqW8Ki5HQ4jIYWiv6FJdu2oBfZiJgY+qfawbmMK1sQ4wpYv6S8=',
    type   => 'ssh-dss',
    user   => 'alext',
  }
}
