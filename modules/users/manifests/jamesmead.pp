# Creates the jamesmead user
class users::jamesmead {
  govuk_user { 'jamesmead':
    fullname => 'James Mead',
    email    => 'james.mead@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQB/CC1AfQBLOCe7ZyWqm6Hn+O5qha/na5MtGuqBwvcSlMN29iJ0753/3Sp7KiaGRqAb5JOpfQo2wmCcX3lCPuskPEIm7j/0xc8fT31BpdftjR/x6bjcYMJIBv0TaQcWASVllGDQOxOaMcv9A9UbxkVHC62Ka+7iSiesRbt3NX3OiDtKnMNyLIoxvKv2weDlm/iJk5D0q799axPhnJdwMhpmykqIGTvgPPE25zh+KnEsXJvlTeABmvosZeava8RMhKaF4h+heeKRg7+woYQcA+C4te6DQ9eWGZl3vPxR3y3a39FNFgF9oIuVVBjp3gbxfHQilzjfl2YBYVsfbQRK1Sw4MLuAP5qoGf+Z5NMIt5GMrIZp9BA/i7vWvaNaYNhhPkzVQ3xHVUCgWrJAPeaWVOW2cKBlxGBc41UsbzagZ3Pe75BBFKS17mblNuBsIwdJYe/KrVzt+eA0lntFNTlVvTsWm69NSBXdrJlxO5jTfQIGdtIQl0Z+jvHTJT+0O/FwloOEIHZ2xDs2Itp8/DdN5Njlm9Mr8RnrDWu9mueqJVEe343y5d73w/+DUt3s+5b3BxiJPekpDhMyODAh7upNwjpEIWujTfHlIFGjvg1OP/rHkzcpSoxGAIdYqR7wRfOMMuVv5/F5d6INnMBTSfOvgTriqAOkuztFwvd7FFXlrPYw== james.mead@@digital.cabinet-office.gov.uk',
  }
}
