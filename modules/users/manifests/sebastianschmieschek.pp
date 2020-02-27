# Creates the user schmie for Sebastian Schmieschek
class users::sebastianschmieschek {
  govuk_user { 'sebastianschmieschek':
    ensure   => absent,
    fullname => 'Sebastian Schmieschek',
    email    => 'sebastian.schmieschek@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7VcUWYh2s+lrZ2/Yidodl0nAU2/hI5LP9RNK2Vx0u05KHp5MP8JJl1oGL53KgVuwxQ0YGm9mJzMVmp16F15H/kVR9HAVHpgqfm/6vRGPoHvkWTXc8IdrhmSO/O+kJO+vhFRwp1SQ1dvoGoEjWj/fJ/9NuMjfMUIMm4j+S6mqG5+qq+lJxd/0yFe1tFnh0dxWbFnUIR55s2FaXNTx+dTMTeq2/gw2cPo/oH8x1OoH4XTeWev7Ey0bMAvqKH0kwGJXe54LuTcwNxCABWP3KP+UZ1/E58D6Bilc6KYH4ukwLukZVFP6e+L6VB8/HJZJU2GTSQmsDdk5V6IvbeEtZcMcdMqJjlHP0IxvmhRt17TC85H29ig23DxSgZsWQ+37YMZLfHrwdqMccp8LvYFyiuWLWieyKNNMnU/cSnejoLykyBVrePjDbSqI8z/fQn4h8JVcol/i2wt0NNe9AjTYlWgTZlKFl5WkAZFfX+cZ84IzqdoXKHFaw9QkHPzMGsV3yQgn2x2CEB+evnbaBBxqSCB2re04zNtAqkQMjTa7xWJ7VglqrnfH2TYlrXXBccGSakhZgwTlG+rkz4/BRGQxowPcANrZAH5AmRvQMpWKIOIgbHpp4vzD4+rgwOXH4sei1tQMS/xRAL191s4Tsdt5xgue5Jv8cZ03apT+SPMbh0TSd8w== sebastianschmieschek@gds5607.local',
    ],
  }
}
