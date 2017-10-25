# Creates the rorymacdonald user
class users::rorymacdonald {
  govuk_user { 'rorymacdonald':
    fullname => 'Rory MacDonald',
    email    => 'rory.macdonald@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQClnRvSk/Jkeq/eshD9aRpLnq8+SrWFFO8qkAdnvDxT9a7yPNxBv9xGY9P5zqgFk6XMFyupl2BBwN2WPTyOnrnQapsR0vIqLwoacaxzcq7f7/rWAunQSXyBzjkKecrFD5ZWJwRm4/h+8BB6qlY9f+r7eYMdm0VlbsgpOYDN6w69ZEu4XmoLBMGU8jZhb4nHWNx1EKNB+RWjFzlLVFgODa6Pnr7FpM46z5X95KbkXtx3GrgdpK2FXRXjbuwKujFNCfy4zf7rXYbe6+/eFj1nVh899DQ+WHHeYPG/ygl4LcvIzwbSGTbkt8u4tBorY6HmsbC/k4Whj417blPf5+Sy3JfCfsoUrLUWmimBHEKpKPCZ2F25YsAZhF803V9EgF66kuk9hNJ9pNX0N3Eam/e8Py/IN69ShohdNlmRyXIYShpFnjE2SycIx2lxw/9/F+9GXiBqwWtTl291ZCxXxJUMIohW/yOX6mQB12RVicRYXk+K1oAG87anID/3HLn6Dy+jheYLsBJGAnIHxmf6HtXyiEeYZbRTVwQ5era7DzYmREIYHj2/ZdjJqSrHa2kRtv5zuuVIKDTAvzErIve9bfxMGyOppQw7bFAfhaxTKS4eS0XPyiS7aYstQ9soFiB7Tdn1b+PkhT5eKffFTBR5PHsvlKapxbN4QE0i/xKdfX05lSenYQ== rory.macdonald@digital.cabinet-office.gov.uk',
  }
}