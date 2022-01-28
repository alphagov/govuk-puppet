# Creates the owenjones user
class users::owenjones {
  govuk_user { 'owenjones':
    ensure   => absent,
    fullname => 'Owen Jones',
    email    => 'owen.jones@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0OZzt4jt3oMZIeZo7/FjMIKIDzLJm7HhnewhIgDr3G+E/KZecZTV1ZCIMid8akxn5jMvdD4qFbPTGdSktXh28MclPiAQwRlunMq21WFURemKFCvjo5/uQIGGikWcDPSAJbPlttcV/0gs+S58fXFekKtV7YcDiQX+oM6MH9FzZZUwhUouzoRLBYBR4yYhZZlYE6SSbVopf0EnLMPZ9ScY1rWaBO2/u/copk6RSQHyckiN6GUSwVKUsPnwACwt0x7CtALr9OiAcLm2AVSDtWguV1x9coN+I9StitXtrvp46eVXYShZiMIjzA5VVVEMqNdsNWI11I2MQUFF9BCwdnRNsngXhod2JVYBy73xXNp6GoUa6+OX8X3DJtjK8nF0/JEp8cPsA5k5H3GYz6GD/kUuV5HxH/skPpN+gGoHdDzgY0O/S3+KTpk2VDP4t3Azy5ecJXZLCAPAhatU9UhGyDY0SJVMvKicFCh1V0SGnpQcRqHmFH08KMs9wRr19D2z8iCzFNYsJUYvNT6ckav+8jFhhFaW/Q5irdxCFOY9HPMeumhtMqsrBa9kS6HBMwWCAhEVU/87taOJgYUltpXV86EBDMPLnj/S+nLxjHSnLhJIwErXngeUzWwy3w4ecMNXZiV8T6OCS1PPXe+8lzMc8vlWUSFqnkH5j9JdWcRU/dtiY7Q== owen.jones@digital.cabinet-office.gov.uk',
  }
}
