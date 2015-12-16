# Creates the bradleyw user
class users::bradleyw {
  govuk::user { 'bradleyw':
    fullname => 'Bradley Wright',
    email    => 'bradley.wright@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsRU7cmK8WRQxthn/QG0zectTZu2JkP9DD3FRHYZdzIxpEFZ+Tbavq8jpRzR0wme/6nsBnhv63jjFcpaZCNkvy/9MlvX4od7Erg9dzuRX2ZnY/+cT5YNXVBmPqh8iMJzXxGPJx2AQIS+nUc612L8EoRP2zjgh66jqcXqAEjTDg8LMX76TFCBdJ7PGYF5NF9WbRptAbYISWQmNm7T0VLHwp+QLtqrlSWiEuwiqVcV32UwnXQJClTTZUG1F1I+JCh6WNmbwvr6M7DQvQYArEblTaVD8//sVeoWxFInDJedelh8Wdc8nNe9OfIeA+7EfPcA6WyhHCnA8CFG4qLGR6E7oe9K1bzn1cOdHX040cshFfx+bt0THUUO4Jzk8LoYQEkrjswXeOSWEFAiDjEK9aXB6suRuawGfY/s2IXMFZSPEfjJcALmjdOo431jHEtcDYtENOUDIso2lDjoq6AFiY0gMbdoAuvSZDhWc1fe8Ol3IQ842M8KJWdBT8W79cLUV2AUVrC+Iw8Vsur9VJCC2IFk+LBUuRnuKT5qFQfA9VmzuyC4vxLb6PdNpxfOskyZjarim4bMwpAkw9EUZzjjHDNeppJqOzkGNUmzZ1/JN0aIGACa/lncyMNBUAZiHajBC7RRNm5dyvb9B55m4soV39VpV3mkyCFJa7o1GuoiC/O8LvzQ== bradley.wright@digital.cabinet-office.gov.uk',
  }
}
