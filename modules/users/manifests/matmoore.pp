# Creates the matmoore user
class users::matmoore {
  govuk::user { 'matmoore':
    fullname => 'Mat Moore',
    email    => 'mat.moore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxbzDkk0LPt3wgF59kEl7jUl8xmKhGTAyT8Xmghf+Vbt7VnJ2fmOxgKUHKcR69asaA7X9mVRcnyRODQfh/B3kPAMJPnBTG6LqM5r6fN0l8aCMBKKPEl+YJlPwgzxgwLSxm0haQA/fSiCSxYl+aFzi+q1ehvwu+cHwhe/4t9KAwFd5EHoKa/X3NMM8QcRJf0f9WK+3xKbw4yhUm8YeXK+WvjKBu1NudxlfcA5/k6GUYWJuU/9oYk0YLzNslN1ELkKV6gcN6WgCQGzDG7lNSDgRtcFYl8wpzbcGhK0SiJV4PD4x9A0DLTfvXRrhW7UIrRiJkV0n61Do2FJuWiE8ImaA0jeIWW87YF8hY3Ut7WaVQ8aT4rmyNwauswWNJO3IONUf2hN8OgDErvQlWA3HtZSSoGBsqBT7afhJLepfJWDJ7mORT0jc/S0W/XnOAvOJUBAyQ+zAEY4+60oeGqBn1SyX+dcBRccnSvjRpnQqS4bvogM7oVitUrUBLiBMXKNNxAdF3bCWEWS2i27NRhjcBVtNmWl6yZ5R+Rg4wW0FDcLxkAeDfvItOv6lA9RINg1W6CAjZhNO5zMxpR05uCP2e+TdTZnr5vhKrSUe0rX9gcSrlVv0hyS1B7jLAnBQUM0MyNenSZa1QY5PsEHuzwUrqu02FSoXUmkjd28N0SguVqStKtw== mat.moore@digital.cabinet-office.gov.uk',
  }
}
