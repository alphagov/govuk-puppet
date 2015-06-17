# Creates the carolinegreen user
class users::carolinegreen {
  govuk::user { 'carolinegreen':
    fullname => 'Caroline Green',
    email    => 'caroline.green@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp2R9Una+QC40EZ7DneycdJySySgqyuJDaWCdfXRnRl23rJoHqr77pikJt7N0Yh7tVIV3LHAw2PVR2amc+pgYkZNqUmrZgYIK+FWGVE1Bu8kr+F4Ezai/xMtvOQ4+xW49UtDZmErA1blK7qGxYqVufZhO7+hj2karikJRGNL8PvcoYUvvHD3usq06xicFLyuSWlVm7bONCAx7IfHZMURbljVy6aHMY3F2eT+eSNlnGzhscx7B/a1iCfyeoy5LWbuhRbPzHti2HgS4YP8alpGB6NgZ0BEq/LfRqyuwKbQLo1sm/H/v5xCyB6GeBn3F1hz6fXtt7rceTNoRPUs3P4olb',
  }
}
