class govuk::firewall {

  include ufw

  # Collect all virtual ufw rules
  Ufw::Allow <| |>
  Ufw::Deny <| |>
  Ufw::Limit <| |>

  # The rules in this module are based on an audit of all ports listening
  # for our EC2 Preview and Production infrastructure. The CSV describing all
  # listening ports is saved as port_audit.csv

  # To generate it I did:
  #   fab preview sdo:'netstat -plant | grep LISTEN' > ~/preview-netstat
  #   fab production sdo:'netstat -plant | grep LISTEN' > ~/production-netstat
  #   cat production-netstat preview-netstat |\
  #         egrep -v "(Disconnecting|Executing task|sudo:|^Done|^$)" |\
  #         awk '{print $3,$6,$7,$9}' | egrep -v '^tcp6' |\
  #         grep -v "127.0.0.1:" | sed 's:0.0.0.0\:\*::g' |\
  #         sed "s: [0-9]*/::g" | cut -d: -f2 | sort | uniq -c |\
  #         awk 'BEGIN{OFS=",";}{print $1,$2,$3}' > port_audit.csv

}
