# Creates the felicitymoon user
class users::felicitymoon {
  govuk_user { 'felicitymoon':
    fullname => 'Felicity Moon',
    email    => 'felicity.moon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMnW5F/gm6YL23CisvKXg1r9hXj5SpRAOYza62nNjpJ5Yc81kaR/Cu0V/Gr8KPdkkTs1g8IubBsKIOeOeTONn0ai6l4QuqNOyeiQiF3Geau7hzvY0YssJpVgrKVIGAPsz8qdB2a4GjsUN0p0p2bMnrntcg79ovu1PxPkQFT87DosWCI9vSzoEQZ1HxdyQGw5+j+RAMkXTvpE/iVB7yTcls9K2P1/2y9HRhlxeZDVw5lNzPfr9WBNtAKTuCs3m1WCTTluNCBF5/936iliuUx6J+LPIErhQuwT3+uuLJjHyeoKHxMvlKdSGZR/OGY7eGOHnnUuMWG4g2Qa3uAhg5SHOX0/CPInGwhGYjhtJ8z5gfUUk96Y65KAmnOFQgqV/o0FGswnpL8m7R44siZUZF8jpsWE16qpSVtZSbWND/cl2nokIqsraQ6RtkMLPen9u3mSwmDao67WDNW+KIgV2qMFN5nfZLvUl0MFV9KxgN5eRlc/Yv4AQFDdu7dFyfRaCPSEjnbwEqA9CZvVqrgNGB92Pgl7FQyHFH0QVR42BL8T0xP2E+VXmlWU+t8kALBz3zSTLv2XzSiXOajtDYnDmBa2pkokMQTil5Y2gfO6Xx1IYpAK2HSbvXmdgRE99UaIPV4nRxJQs45HSsaW61HQiRCB/ztKLVirY/CfBqMJ/5t9bmQw== fmoon@thoughtworks.com',
  }
}
