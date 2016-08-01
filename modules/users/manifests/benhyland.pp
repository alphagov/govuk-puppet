# Creates the benhyland user
# FIXME Once merged, please remove benhyland.pp
class users::benhyland {
  govuk_user { 'benhyland':
    ensure   => absent,
    fullname => 'Ben Hyland',
    email    => 'ben.hyland@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvJ1HjHMGA6E7yGhvAPx1FUXY/xfeK6H1RT73cWR0otXPe4Z0q6bg/tzs0eyT0A407cneit6ETb2wdUw/LeUZasFXnX+IGm3PPrmKzqgBxQFYMTl5YlvK6j3aRyHCY25o/UhTAH6V+qYmWUYlQyiHcRAlP1K0DVkLHRJWScBRSXeNrwBe4ZxcTbMDVcZ7l7XPTDsup8Q/ukXcyZ87I5JgNVDQ4laRnqfk5sON/WfhyocyAj/CL9NVsJjjH+5gQmbp4AB2/u07ceqywcWSwcxJQxePuSqAcumfFI5D/ny4OfPbWNZlQHzd8vMMdZyIC1HjLVBiIerDVsq9Eu/tKprkyUJ9Gp8L1CjnK29vCZogyOVy8vzDDacaf8v99WIPcf9WcRXLsuNevCzY9TCXDQLBu/LPUaN4nKy/KaodsphT3WdtKcjkG/CWH1KSvNPxdnj91CemUvRjoLHA0KmSUmW5vlzL/wPNQMJIn+yO8j4Lc9Un0U3R68qkEjcULtTQ4c7c/LB1VhV5PHc3L7SVEo2cfLXT1FEYkV3Z9IPeT9t4D4CBDuCxwQOiHUZR59btLVmlPeqWcZ+PkOhAx3QKGBrxqOkgf5vls9Zkybabl8NhljNZsFTp55CqO5Jr0mVGQQW5JWojBFVbCI+Y7TGC/K5fZVLeqkGzXqP9tHV54FHpz6w== ben.hyland@digital.cabinet-office.gov.uk',
  }
}
