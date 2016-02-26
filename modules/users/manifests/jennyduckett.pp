# Creates the jennyduckett user
class users::jennyduckett {
  govuk_user { 'jennyduckett':
    fullname => 'Jenny Duckett',
    email    => 'jenny.duckett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtChH/aBoCbgossPnUCUUhdSNah/dBZqqbFV4zDY+kvdB4N73nt3yGiQnLRp/9aI2oHI046coN+fDaNIcaJcLLXxqavZEazP/xZab0zDez/yvxGGPeHdi1iMEGg0EpWjKKHhvONWgsGAkHLObIzrcU9+GRcyn68CeS44hHuGy4LQ6fYVsi5iCXziGpJCTND13gK2rpl1tnr72G+dJtTRA120eO/2ZM4EWQpbI1RpTcBDABIBa22SNM76lazNiVDcPG88igP9QPDlAGQSXXIz573K61M+Gtm+jGyWnD9Hj+G3u1tQ2UAC+D5Mc5p6B/cDYHUoEQgcIwm3yuTJPSJMyKy/u2dCMmvRhr7rCMBYfWt6mprQKubYw64lGVItpPswXujmSWmUqHILCMY4Daqt9jHOe/cabjEEyrtqxWPj4JjC+lUpX7aoMfHmNqVi84P/E+0z+eA5cL+4wbeeJYeHhicXOQl2Z2NcmKBU/kOEoLO1GeO1w+2GdMQQt1SpAiHflBnvKo9HcrHZVaRzWH/VPehfiQcwjiWD/lpTRnr570nM8NudgxQOtaV4vewM8VNrT88E0IL4uorO/g7FiY2d5KV/g+Gvre5zsCBWObAze8O1/h0itcJ0zzBJ+BVgvOAMUrL7V0pYjKkmsXVTIXXcL8iZXClz7Q8kmYB3Be0qKbdw== jenny.duckett@digital.cabinet-office.gov.uk',
  }
}
