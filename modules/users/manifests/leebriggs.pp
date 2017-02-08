# Create the leebriggs user
class users::leebriggs {
  govuk_user { 'leebriggs':
    fullname => 'Lee Briggs',
    email    => 'lee.briggs@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1Zuw3VbMjIt/3eKvL1RlbXRzSJCPHcGxRAVlTCWjCrUDTjrUTVQe65NYJqpsfTa86gcBqa8TEUl3IUwA0pi5Eo/2qNlmS2XPtrfnOE9L1biZAGaz5UZ8u52p28Effl17SzbHQnyAwc3Dm+IGYfSAfOfPyq2JSfoMnvW5IUBq4Jtn6/wKfc9ShmisQBBpfU5rZfR+1UizJ2AjXeHelB3v8ziOC0HzdWroaE4POCRkCpeG4A2qrSTr/pMXcjtqWa50eLVn9qkW4EXLmfKDAmP7AEePGuXnhY0T5B77s3+dCZdMAbaiJMFHZeqYyWIJZIgHfM3+Y/LzUGnH55nvB4QIYN3USB+YyRuRMWVYfCcmsWF7KUZSt90Q2uv4FZYFqzk4JPHBON1uIFL0S0PfIrRkT+3jxkn0z00nvKll4jhpqZ0obrXdGzkP4JUcfXkhBb2npEARKxjwsBOfmW+dWMwCPPidkQsnplLl6dAjYd1xcgGmSTqsfdoZ0dJ1T8RrHbWobm82j+Q7Br+Nd98C5uFREfoMAfs7EmddqeqrNG6rjeeMIYndIxSECGRc6xDjIJ0gs5xo/KdKXFXR76iI7XXMrl9V7fZ7hRB1zHJtzgEwDQP0pIJ2VfdLbyKj/S1o6cDtMTGcfHNptirTirXy5d1DVpSixaJumj00Lfoane9hzDw== lee.briggs@digital.cabinet-office.gov.uk',
  }
}
