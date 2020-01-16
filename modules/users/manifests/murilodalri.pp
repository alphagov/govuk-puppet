# Create the murilodalri user
class users::murilodalri {
  govuk_user { 'murilodalri':
    ensure   => absent,
    fullname => 'Murilo Dal Ri',
    email    => 'murilo.dalri@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtPnAfm/DWhfOs5UCX+WkfiDg3vvCdYx2uQXNVE0geAoGM3B/5ITxeYMUEIUjC0Nbt2nqQkNV/feNG8PHa4MopX6btS0VxD3t5s/slyHu8oCOdOSW19dTFVIa5EFdzDJWauNsnuXITytW4ZyRL2hmOzUpiqLlT+2nuBXzSQt5xp/yJC9zcx50CraIbcHVCBE8Qxc0oRwWhbwy276Twt6Tf8puutllyEOiI91L1sUJGFt0PKqskjW51J85U17QfW+daz3o9O6anGf2JOYx+ud6abhNyhRJhQ5Pvu11prCqXkPJgD5BY7OHu2hLzMgg7nUwhyhsxgp7zKapgmJXDsx6TZMrkqdancuABJMR95cMQ6Bexb9Zh2J3eHMUn8zvMyezROGU6UQvt45gFJ2Ag16zY+2KLsoiW2VEmFRDHjGWshozDKIBaKmkmttoTl68Z0FepzfWKP3hOGCS0l+qDWPVohhtoqMaYQKrj5Of6Io03UfvPYWmCLggegrJ/qlGkHLRnw48kf+D1ApxCQGG1L2ZVDOioHYqArtwCmWNQksGfPY77qFecnTwWeE/HZlQUzPbXyd6gTOPCWQL1iiQYyZrmVCa2q3jIK2fYfzf21p0WY5+l2EiwGqdGvsHLE6NCCV1ZEXzf9lBzb58ey9xAoDcQQfUxKoS69L+/QlklfIxtOw== murilo.dalri@digital.cabinet-office.gov.uk',
    ],
  }
}
