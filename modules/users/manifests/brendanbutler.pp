# Creates brendanbutler user
class users::brendanbutler {
  govuk_user { 'brendanbutler':
    fullname => 'Brendan Butler',
    email    => 'brendan.butler@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5GqE9ZyPi5nWLGeXzqgLL+vUYiGwePulBhCaeiIMXmDX9JVG94r4o/WgUgkOLiON+j+F4m41GMnHsWSZ8+Fd4lJHHaIuX+DtK6COsIyezIF/4963wRZFaak9Z8J1XX82Su3wY7DtBuszYZEPon8uZj3/hGTmSd4Gm5x7fVZSCAiv4QTICCw3omrJw0zIeKCQCpmmRIkyHu1HOcz3WB4hJtPDgmZ5OgPtZ58R5pC6j0wzCoAnerNlXC/+t3Z321zOF9PNgxdqDjkElJsWioB9V3/MZfVxj3u1OrYWBblv92LBExHpbZUlrw9zxEDcugq/KQFG5eva9RjeRxZK99OAlApRBfYEL8/cEnxp04ZTTfPF2RrFlkgpZ+xMZIfm59uo/zK9sLB5slOwryhx3WeU6BDAJa+Av0cU8bj8j93RKyXsnhrBZIj3zttDfD5zogX9DCbJ4xi12b4PzpMuR0FaWOVc5qqcWWBCVXZmUoF6DYpErE+jIWs1TAJynr4/BktkQQAHLf/K0VrT6JthrWRGfegqqBvwLo7AeXdcNYwbp7H/blnroBVWNZIRdjaGtVncaFLY21Xvy0gPlEbW/w+c3UqhS1dopjzg/QLRy7uSxCRLJfZOGRvY0NVPwB4rxb6tz68ZSbmgfvWnDQSLKyWyZPb1t+XB1IA9L5vd9lbgKWQ== brendan.butler@digital.cabinet-office.gov.uk',
  }
}
