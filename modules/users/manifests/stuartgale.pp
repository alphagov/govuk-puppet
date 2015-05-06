# Creates the stuartgale user
class users::stuartgale {
  govuk::user { 'stuartgale':
    fullname => 'Stuart Gale',
    email    => 'stuart.gale@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMlIGdH3hOQ8kz+gZtIsp93DDdrd3iQFlVJc/cAd5i7+TLnJ+jQjb7A7TGttBa8IVtTgxOtZGm6ER4dJPUR55/yGU24naHTafGp/OfTiKvRg7DpN4SQFqNy2g8jesnZdV7e9NnUGfFnqduf9UcreumIYHPSALvFbAaiyTzbUrD3B3kCnYPp3NZjVRur5PKZSHhf/3Mr4vWWqp8wr6JS/HHK+UMBdLqE456uDPbRnX+/TF42BNDZlVHHNwWdZ4xrnQLIl9cfamYOjPwYb13tnSFf8+gsf9nXZcchBARYPannxOCq7MxfbropLN//AMOn/vc1cCGUNlVcL4FKkcSlwIr',
  }
}
