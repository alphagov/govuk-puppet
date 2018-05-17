# Creates the stephengrier user
class users::stephengrier {
  govuk_user { 'stephengrier':
    fullname => 'Stephen Grier',
    email    => 'stephen.grier@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSkCbLUgyNiCh4mdfY1wCjBIyxyUidJgq7Qmh4/XYB6aSXvMjgb+YntfgPB4bWT0pKLKx0+3LWEKuYYvdJ3UOVxdAfrMPgn0/6XOLdvY2ywmytqS6MUfg7mCqFSSRaQqvS6wSkHkJ+u2mzDFeasxOS0EMyfVKTGX41RO/V+P+3RAwga88FGuuaxfCcztjjLrMPK5wvD6cHdtrYW9UsBshnYS1QPGaU3xQqhdrRvJB74ndI5gH78nZiRDguA2LoEwbQdvfotQwQIvbVeN0fCyOKscdxP4cSNvWiZeEnq0kH8/1mDO4vzvuM55RpuhoI+J9JXrduLywmwMJuf5gcYmWQf5u62CS/4YVTDKVIRmP7K8Px2PXUMVRMINk03aa0sU9KoQHy33aD8FRXWmUQWqb4yIqjpo7rljcyMlNHFmBS/F+260L1FBIAN+kAA1dJQNzydaWkYtot8oBeo+s1Y5UKT1bRfz9xUI4/YFOmgcTfIQSYcC6QV/PtpIlND7Pf6kIe7xlN9FZ/7rQ3/YuR4GaXT+L3myffXfYTviAdaOp6cleKbdH6dFlRLQCDYkoiEUipxuMT0YTxFxix6QJxZcFXKDEzoQsZhPFI/g0Nsjnh59272qT7jk9UGyVvQ3O5mD2ssvvoREMVzri42Bm4vRFXhmRZIt068ghZGer83fS3uQ== cardno:000605972621',
  }
}
