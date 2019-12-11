# Create the brucebolt user
class users::brucebolt {
  govuk_user { 'brucebolt':
    ensure   => absent,
    fullname => 'Bruce Bolt',
    email    => 'bruce.bolt@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnG3QoS+KBxRVvmZ5zITS9U8ZNc0nljyr7K8ol4ndkYfB1M+sT0FuBZ7zsrGgOPBIJLZlgvd3+BRys7tjlDTkJcBHHR5sHhpbcacpcfl7OTG9d+5HMr4xY7MmNyrFTKHQq+pvPWBg0QvK/i06T4vUgxPC0gacsN+Fk8mOH5OAUG01L5mydZAl56uUDERhnfmYiMkz7GRUXvvJQRZnrSfi8H0I3fiBzixLRS+CMNJPUGyok6BAZ8s6xIywtA+pc67VLnsLkTyWF7YAKZoO3SIyzQ8t6g0FgSgndP8Sz8UpgD4klB4OSiC2eWS4T1cytwdZm71y4dH2lvfJoGwhkMWNTjRin2RNUHdwCNvyxO5mIeP4xqye+TTkuoGvdahRT8aad9s6E5lTTdXRSoWmGk+A1wMgKuRYbwKmX5YLtIKjOtDcpIiiM6xaAHc2m4niVzsKoZe0JT07HxZGrt+tdjbsn5IgUmqtKrZWxFtbT88yC76nhCSTAhpOdZfV7SguHyKOoxQH88DEghx6F47hQUnHNIRH4KaZsjAw9/Sn4Mw/98E1L4GqWGPWb/CDYCXDiGQAuN0l914Fl5igUHm19/69c5zqckVxTI1DIirqCIEisupz+HteNgWfN/dfFaEI5eKjGH25dWOBX6oHub4mVNtGp5izeY7n5+QF9LRqEnf6/uw== bruce.bolt@digital.cabinet-office.gov.uk',
    ],
  }
}
