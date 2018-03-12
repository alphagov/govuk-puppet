# Creates the danburnley user
class users::danburnley {
  govuk_user { 'danburnley':
    ensure   => 'absent',
    fullname => 'Dan Burnley',
    email    => 'dan.burnley@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD2CUYqN2lDaJPSJlx32y1yI71YckOaZYFS2HkMsLfAAgGzg8xj2RVPjcdtsY3QgsWg4Soht0bIhvSBEY6v4H6dLvuL4yEsAFhqIFO66ndiniQklPc+7WI2CNOxT7s23R0uJEzoQF13T6aqU9HbVILFPfRYQAoF4slIfd92fIh8oUuN9tQRic2rpVOi2BLIYoflR55lm9/ky3EjneEk7Pro6ptWCQ1PFDxm5Xw7znhonkzDyhBLhWSQiUn0PiKrOuZ2m3E7oNZd6o1YuYGsZcwb5gOfBE2rzIBPWSUh471/BNIqXXRhzZR9jtzVDXIWSIXl7EoFb7yQD4ojdN6Gc/WQKEaFX/XdbBPXKy4/tf7ztvWPUVQZzYyUC3GF9R5ZUbALqNF13hfHAzuYiF4si1QNYEZ8DhReZCvwqARqTY0UK+C+vKZGqhbUN2coWUZ/SD1aPGen3vlcNB2xJfOt3Gx9zsdWSF1TjjBU//tIDoOJ1uTaAsv5x02Ee2IZVCu0iCfCwUF3bprWt1vZ16kZUyQvJK6meeagvZKPOE5NQqEt51SOOnM2NtjhVJJU67+D5K/eB98wwI+vTmjGcVx6jwo1sYkQBAMudG2RdmZ7n+qxl0j13vSOG945GUjLKz+GTg1yCvNULHmVVq1p//M9F6hcNu5XWRnOFhwkgDexEwMcw== dan.burnley@digital.cabinet-office.gov.uk',
  }
}
