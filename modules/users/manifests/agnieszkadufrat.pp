# Creates the agnieszkadufrat user
class users::agnieszkadufrat{ govuk_user { 'agnieszkadufrat':
    ensure   => absent,
    fullname => 'Agnieszka Dufrat',
    email    => 'agnieszka.dufrat@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcAvH91oGuF8ntTZq+K/HfUmhSG7vilh+UBuKlRB9IfNcReh8IdcRRb+UUs4RR0Rrd9/+2mQQ9KmHFIQjGQyXpr34CtWopqFCeNedFJgu5Zw6giSSn9O6Pu79p86YdZdr2KH/FXMyJqP+V7alQdlQ3AlSRRyM9ApuC8lBeJl1FzMIxx6d6i0l1l3F1Ju/YPj3Mxq65K66aPwblwoiXKVFJbpwA434XF98Jjcpyq8J5MFWpr+i9HqHtwrwNXL5gvLP8MlzWcwtcs1qBAwGiQXeB2wO2jfwndNcYSVJ/z1K6/GwbRf4n/bnxykp9HNoTqD+f3R3hscBtWQtbZTuh/jgahWcJPbIir+VphbqEyR/pgnJTonPpRHA5f1KJzZlABOzjEpxk4CGRD3QhPFVsoYlXDCUN/Ehjp99VJeXP0m4ays111eLouCtdhnd13ev+Y6khiEtHc7CrrXNYZX68erBEoQsXCc2d/vbRyY6FBmq4xr2gtN75P6b15YxiU1tqiQ4VIUk7eupM7ydnJPbjm8rr6S57/2/QGCtQGrhs6rrhDv3+t7j2H8joO3eIvYQ3ZO9uUfpaHDOlXfhusGV+M7+wHXeKa4fxGWWaF4YiwwIXwJ8M36Mou8fJ0Hud+Zk5cgk4iPP5A+KfuHmse2fvTN7wTZH6dMRRk+aggJXqT/hhzw== a.dufrat@gmail.com',
  }
}
