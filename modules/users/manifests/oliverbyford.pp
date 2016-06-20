# Creates the oliverbyford user
class users::oliverbyford {
  govuk_user { 'oliverbyford':
    fullname => 'Oliver Byford',
    email    => 'oliver.byford@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnLmOz+VZxBIkXuyek3B8xeHanHQdUiL3kYLGtHwc0OVHtjDxZKAmQMyhT7FZCUPnKqSjUXhSHPqUN6xu0qU5ED+VC9aSIoylei/BpcCzCUUG2jo2ULia8SEnuTEDvrj9Rl/+EsbqCvwGWIBd5THrRQBA9n0WvkrF+0fkBXLYCGQWx2X/4OE/viwz4jaZ3bZnmp/58B6Rz0xDnLWBrpr2uJ833KqIwKM3D8gV9GAg4vwSSkAcsqT6sO4XpVm87HMkXL0qEhGMs6TVzGedK7/EBvZgYOqOt8s34Vur4ufEFBus189qhv/KZC+bmcleqqoa5IkskXvaCAIAmWzxVIISwKx+q1g43FFyssHiMocCDi2g8UJxy9Bc7I3rRDNSvq1av8pCVoqK6HpP86twRUQW3L53Y1p7/iBWYgem4pqsKPP5/3Tmzj2tLCosmAt9PR/gOz18FjuVikjdz2JjynRhmJ8xLIjIBuckONsIwlkler7tA/fTit7SY/JjZQhK1ifc8IG5C5xQdeTZBXx1y9DchA42tWSmB2Oz5fgIEL4Qp6qDjLii1fMnhsD6q6xM3tuxIr5TduW0I/18bK/OhQIt/tW31uQ9u+0tWWsHBlzm9pkvGi+bcfCTnif1wE77lRuqh+oy0U6ZXgTAR2aYWWAoPLv+yXkUc1+En5Zy0W5iTPQ== oliver.byford@digital.cabinet-office.gov.uk',
  }
}
