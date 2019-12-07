# Creates the user alexandrujurubita
class users::alexandrujurubita {
  govuk_user { 'alexandrujurubita':
    ensure   => absent,
    fullname => 'Alexandru Jurubita',
    email    => 'alexandru.jurubita@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtjGB5VOga4tRQ3sep6W+LRuYMCP9GpsyqBlv88axx0ABSdl+zvYLOIla1uVJhj/jyJmzG5O8mNr6RKf6osAikkC3cu/zp65jqsDGkbrkYDHC4qGYDQ7+6dltYtqZ73Kb2j08JxfCHSJ/wFGbcSIb7a/UFHit8niUj2ZhJPUmLFUbHyuj3HGSLKC2vBtfXY2JSTDTpsqBG2uL06urx1sxqHgchZ8gWbNFSOL+B3IVH8IZJy4TMX7tv/xgo3st7BEh/eh5qYSGR9SFjv9udaRorWtwUZ6ufZQgkj+k8NxWtahURvVNkB9mn+a4h9SVsPqGVE8y7AMXYkkiBCYT+vGbQ4FSAwEYJRbVgVDCWGQJB8Csg7VsRQeVzSryxv6Ue+UIKUaBAx54UIv8faiBOsfvr+RN6svBMZDxHyJ2P1tC3gghVjRnzz3qQTF9+mDF8zEgDtn6w543J/SmYGrD+KaN5inbB551VOe49uG3tkQQ5kgFjaOTjvpXIj2hsAPuR5q6Fk6o7aG21OAnMIrEaR0tbNlNIHlL60K8RHJMqms+UCY2n3FGkhAOjsHT/PSNRTS6rK3Z4SDJq38vbnWfC+R5rksuG3DgJqTApQCSOgZaGBmPhpvxDJmk+GLhgn9SHScqZOwgKjfL+ehDW2EnMJ5yr7fND1Fz5Y7Uy8sRro3K+bw== alexandru.jurubita@digital.cabinet-office.gov.uk',
  }
}
