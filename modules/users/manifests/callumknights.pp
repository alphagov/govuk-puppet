# Creates the callumknights user
class users::callumknights {
  govuk_user { 'callumknights':
    fullname => 'Callum Knights',
    email    => 'callum.knights@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQiscE6q+m1VsbEh/g/FH71dFI0ELX5PubUxfQrqpU1SqZ3zsTJEYihg716O7UZyC7DWkB6iZWRyOELqGfbI84kLX7q2fEcCehRrRLHHNYaWgL4SM71uJ67yG60xaY9JCEjhy7RvQMI4B2Lhxkr5DDRBl+d+d/E5kQb5E05BepOubFHaDIsqygml8yrgwRYtJeTHRqLWZCwaWexLcmZeanfi9s0ZsRJdV+SyBAE78jGXbniuRyIBvsKxb4CcOL4Sa43HN3brbVfLzK+UoO2/ZcV7biyZ8gVAdk9lL0opJJiw8e+JDXMgyWYzhegXzhHPIvpt5b9NNcrkjcWkNiHLoJF1bKpe866pT6WMPmbA5UhiTfHDJ3PRodE5r/W1YyC3fI4GzbSfKGyTvqctjfwl1kqwg0wCiEvq/wz4IOhWqwU20jc6bXFZzJKBI2m2X5/xdyGAfNg5N2moOmXHJNGJepR60RoRmiW4lPTSv/LCFRjQrNETICP3ByKu/ITqllWdne6LEm/5HV5lUxBwNB3KITb2QaV6vkN/eP6G9l6SsrXP0PCybZBGC2hz+yOVxn/ZF/OxSwHSsLw1oc+zlOtChSEoY3j7qYaCO/UD2bVP9PqDjZvFy8wRva6cr5uII/C1Xb9xAWGwvMe6s5R3HBBUj+4Dd6w3Me4OMkM54qVjfE1Q== callum.knights@digital.cabinet-office.gov.uk',
  }
}
