# Creates the fredericfrancois user for Frederic Francois
class users::fredericfrancois {
  govuk_user { 'fredericfrancois':
    ensure   => absent,
    fullname => 'Frederic Francois',
    email    => 'frederic.francois@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDf4SmncmTIxONSA93fe69TiI8toxQQGhoW+rAe4CIVDXpSt8VPFQFtQccDgPSx+hltEJ/62r5pyn1CpD6bjXGdR3bl7uDDeAKH2+IaoDjccfg8be8mdGqN8SDBZRQg8MLtzkCvenisDSRmsGwvS2ef7SBk0c/OglrIwzxa1SHLFgcXMDurC+rGy+vXVkbJry6HIF3CR3lSNTKo1XAR7lI/UYGWR2eCXSRa+PJASEaqh7okd/29el2IxoYuAxZaGkqiLZCZ01WfVBmRSSbKwR0SXHdKxBVk7cMTg4oNiwwDAjLFIAQAACnxqgBEIeWBqmyAhDS6kqeZz2pdRK0reh+idm9RU25VZ2Fkmb3Vc/xwmDVgqCb+GsSVAtMDf9gBFBtriXWdY5ACsPVss/7uShsvP8cYlb9q/S39maiZ2BdbUDPhMvBpBzV5EciR7wqXtx/QVyiyvaN9Biw7qKyAV7MGpeZ7cWYX2r9nfj1y2fOgt0RpUI3hD3RJsyrX9J1Te9D9d/hWmHEXtopTqoc7tav5rGBcOVKUaRrqL5YAdztoQI4f5A7IiTA2CjmI5NrQyfbwqVxA/OYQbPMRxUif1U+38SCekTEubbHmlv1gSW1t8uRctEmFooXz9LJj3m7HkswPr9N2m2JJuvUf5rWO47z12NhFtwpvAgMpKOjmazalRQ== frederic.francois@digital.cabinet-office.gov.uk',
  }
}
