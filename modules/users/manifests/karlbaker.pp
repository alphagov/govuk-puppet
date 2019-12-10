# Creates the user scheme for Karl Baker
class users::karlbaker {
  govuk_user { 'karlbaker':
    fullname => 'Karl Baker',
    email    => 'karl.baker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIDxPsmi5/Vfqai9OhWXgD6fNvJvHjbNw/VVNw7CjDPJWFKvK8ZUQLvYy8nmmdVS/TCuuUtEjcDJinz+dt/feGviHrO8Mo9b516jKa+al4DwMfR7xZ75SS17dsbo+TRw+ZASVEqCQl1hUJ4JKf30740KrbAVHJ5qnPrf8QcE6NEn68J26JpxAmaCbfSgRnz2qc6+uTX+/ROjJ7qXeDsrLBGRtIX/dRqcaqARMP04Gsf3t+WMa8JsM5CQs+oSi7T5UHkGv/dd0WJwWcIVZqiNXK18jW44xFihu/0yzayXCUVlsw2+CMlPBm/MV4rIxbL42eILayMz4Ppk/4ds5iYiyp6kiED7JO2HRlKVcsjcDpg32pQIgw7FQ12jkgwitPrt8rvgWoMwNzo51xVnL4MVhFG423LeZ8Zcs27ruWIdCu9/6kXj5HYN8YCSP4i4cREIcqs12GbpizzCT2R/idBRT2q7I32t6fSVonIq5y1svYP20/JOGzX30VoamVW2LOgziaI1bsrSuST59kM0RDuB44CXtffv4JK74E4aJlUu6tByeGAYxkOzGHaoFM/a3dZrDLx3kF6RrdWSjcAo+FWHOSKK2HweJokwAGYn/I29ZCjfGKmifjt3NmdqbDL3/dbIx7OAcrDBan0K9yeprgGOgXvPiZpGUiBPKiYOqxj/gJIw== cardno:000610162345',
  }
}
