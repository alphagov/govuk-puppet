# Creates the bevanloon user
class users::bevanloon {
  govuk_user { 'bevanloon':
    fullname => 'Bevan Loon',
    email    => 'bevan.loon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBGHAxRZnVToerHsYve8oeN61qHOWRS1SwrzUI8uMPdbnZ4Pw2WG2GalYQOrE9gSZqeRV/nms5i+b6SReE/Wqr1twXJF7xcvayUP/r9fEYA/Gam3MUlHYsRdP36bOPEkcnSAhoQyj7EOe2vk/5eeiv4AGlEGZ4ZW+wI7uEqhBp1O+pheHtzRQpeFLLh18Y4CSpdbSJknRMSZqb8rOl5mQzq7iqtuGdSpeRoIForCZhywiKde4tFOgPaaAQwi6GFURBx9FiI0hFiYvwhn84mkGt0doEdJE0kgQe1p+1G0tbSfQgtGtOzQmPxrna09qNQ5WbnaNUNSA2sKWS1bNW+MRZZJeawM2S+4TFOQyB12RDiAbL4QQHL2ZZIZol6gobl/dMPc9bmlOYLyJPJjU7BIVnlHJjPH832kGprr124CQ/3n8I07VkLrZ9psft8IflhAun3keUXb2tCwQ5HIxxm+WJNEPEWHmLfA+uvxcKw1uo+UgwsfQ6axn7VOsHHhuJ5C/rEbXQBGSmobtTNLEE+AqiVyTw0Mxw/Iir3xcFCrRDQXgZyHTYN2Z3TthsW9ykUplBFcQ89ACAUwNIpLWTne0KKfE/O0afgByYz8T3JfE0Bv5tm7lkrrLtdJwAV0KVfXiMyZHlMyGs1QveGwmllwOLy6blZTQ7rW8d6SPbFZcpjw== cardno:000610162314',
  }
}
