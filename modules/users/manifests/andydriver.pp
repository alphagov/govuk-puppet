# Creates the user andydriver
class users::andydriver {
  govuk_user { 'andydriver':
    fullname => 'Andy Driver',
    email    => 'andy.driver@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPc595YCy0ut1smisE0bR3PWYu1DG/Ick7Ux0Jb6pgoqBw/Zv24Y7Z3l/AsueFQUNPYAagibrSRAMah/heNjRM7cEBLKwLWmhPnX413qJHR3vUDxg39GoDGwrtA91XwoRfeO1cYSzwu/YMefZRcM2/p/5y+0q8Vqw47+2lZCu5tBxZRA5iz99356H3CPheVgjmkuuGdKVeNEIouRqHWEBGvj56M6FjvUVvWJhS6zS1SOJleB9Dk30pNwlLnICb1DeiNDRN3JVvGPHDUHcqKfpLpW68qgM5iBMUSSzpx2CxHrb7GPNjYQf5drvRvCJm9h867rh4FwEmeAtRE8wZ5xj7FC1Bx1W49gvshALQcX+bI/003BPaHpiUQRpU8TwYM6aTckUKZ5NFL23ciUDCK5kpL1eGKI/IIz5gqpTxhYhdcXnXgshU4Fxm6Egc/LuBl3UKYEiVZE4gHokFiOCSgDc1/s68YIeQasFHja5ikDly5WfgqHlWRFEQo03kMktPnL1vYgvV8TrMDdLvRtnlimC5uLolSv2367rdE+eSIG3xLyhEv8c9LkPP/Rnifid+z+nUcns8wwOiBpjKcpnHaWnlUmZDwgEHWsEVr+yvpZOr4Oy/jquCJUiO5q8tn8e77tdZFMozSTigntFIvm1yq4GjwN2YnnpPrbwnseEzyh5l6w== andy.driver@digital.cabinet-office.gov.uk',
  }
}
