# Creates the alecgibson user
class users::alecgibson {
  govuk_user { 'alecgibson':
    fullname => 'Alec Gibson',
    email    => 'alec.gibson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoxsxA8nFe5lJnNgvis7bC4YkF/ZVXrWrebrOt7w63iV6prjL+3C9w2ddqL/isD22OrGzKeb4oPfBopZf7tJGnwCLBhfDaZc42FgjwAKm7jkFQPBdEaozHwpEn9P00gk6tEm0OAQ0FL+QBZxe0B19CryI+6Pu0L3Uvmf3iq39ZcBkd4a+kMlWdBtLbEOHBTCZAUXnn5iTRxWGEb6iHNaZj8pbQT2D8ivefPE5GceXfwojh0PXXUsKHsGXfWxzHD00xr0TGvs3i6+a3lGzZJWF//daOvE2p9Lge12916p71OmPrcHhcnHFTHEWMXHLi2rzbErlP/FpxYbxig9pShV1Br3zxqUwNhnbiJOvmphQEXCqGK3VoxMb+A7FBpZZdZaoUgt0DfTuNk18a4d4riWYxC/82SkJ3NSCX8bceKVb65pk4tPqkKbDxAW5R/J+mWlYeZbq5UmG8JLqqL9WGo3HKuYwKmyJX+Bqf1u9ACViAlltV4Z+avspcEa1wxvcpHr2xz9HqoFnsrsAWHjZ2TLUkk0cv/Kr0f2w1of7XIobxa53Qpywjv/WQe7/edb6f/Vl5BY4zQl4gYJkWDfBEMTNZ0NIkmZ3VmW1e/LEOGPGLSsKYBVx71WskhO1/dXArv/O7UxxxvBGID6fVd2iEMwkek0dk8RUSgMZeHJbHhbaf5Q== alec.gibson@digital.cabinet-office.gov.uk',
  }
}
