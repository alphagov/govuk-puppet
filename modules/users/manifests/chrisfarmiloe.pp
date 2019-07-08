# Creates the user chrisfarmiloe for Chris Farmiloe
class users::chrisfarmiloe {
  govuk_user { 'chrisfarmiloe':
    fullname => 'Chris Farmiloe',
    email    => 'chris.farmiloe@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2BpwZWWArFfIERIuTk9vKRrAjPf7/gcMVV0tcunBCnI90WCLLsW330usfdXNoUOfmMwdsXusD/0O9+JyKx6E9V7/TcYU1GQay8nEYVWu/ZMSolRNQsT8OuW2+9wu01Xc+V6T8woOnwKC8ixtHgbcmD7dGqrMTRa5blQnsAoWMOyowHN/ALOMFdMmv3MHEyN9XruMy3KESLtLM05h2+hyVWAZhsQMq1gHTKHmMLMdT4/W1sRWt9ICEecBLyUepaPOABdd9TbvJeof4Omxdj7N2cZ0Z0nHGuzazEBn5Qws13GF9TRbDRavtQeRxLBL2xdpbTt5FAURR0VdgPMX4s3zo0hic2skjHJmH7S0nt0LgnGEwmSrAZGw9cPXcSTfSV4Pd3f9pfSEUihyAfdo3GQVGyVo2ZVy38k1FvzcbAynP05AHCchpqPy8ANw94lGSocWKpp73MKGHWH2bbaVNBUDJeNc8hxEk0rsRxXLXDaa/cl+XpKZrRmFOiUYLd+NlVF/leHyNP0WyXZq2XOCRR1pScAt71OnK8FNL5aS2D0jXoi4R5NWxsXcC2Jr+UalGpsXhJU3NVzUXu/YfdObHzbGRbYHoBWAorAQPMOzF2ohmPiX6wTNC98KT7/Xek+Dp/XLgY27Nxt0bVHyJM2xv/jcP2ldd3y07BOXo2V5uP8kNuw== chris.farmiloe@digital.cabinet-office.gov.uk',
    ],
  }
}
