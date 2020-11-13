# Creates the marksutton user
class users::marksutton {
  govuk_user { 'marksutton':
    fullname => 'Mark Sutton',
    email    => 'mark.sutton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJUM2KYofB/cvKkRqv9QAzQuFrvbNuYCHIXGZSofV+Sdkr281eTU+ty6y6H6POj1PRvYqndXcLhl2KDvT3hL4FysQ2ipgCLK2w307kogtr78tjWtJRvPYgoAopTs4re+8fO+dGJyaT/ky7SZTsWu/G/drzF5gSwTfyX2V/VHgMpITqGAhOsYuAL0+PRfo2LLkhayQsFXM3iHEHIXQEYSMff9cVGR7DKxkvLAindDDRg0J15JS7hWNutck+8h1G5/o54hi4XCjOuHl93RZT/Q01VrJMVRWWtibhRVFC9crlusX70JfFRluVMKRU48x+7GobT+7IUOnlRNwWwe09kcHaQm9fkpmz7yru/ZHLEg3/D3XjcIObx5TThadqY1Y2ogsoEFOC+IPIb/mbYmm8AXvieNEKupGQvtAirCTYdc+bhto/0XjMoit5JfeH5zKRsRo0YcVfcDNVTpZ4UwWTVKmCUkWT8bjzxyoF6fbN11DCcUyi/U8/vQLOH4oRrq+/OSRGqteGlsMjx0n41rIfCHMQsFCEO8E2s3n56pIoKmjlIUJrrohwl1Ui+2Z6VnUi2ahpSN4/aGf27OuHaq+Kzdk/zvRzpqatv6XTyEhubkw3aL5X91CUP37KKcWDuP9SlGUI+ni6xgpjfzJODmPzIxUTkslbWJFEyItyK6/q+FDFWw== mark.sutton@digital.cabinet-office.gov.uk',
  }
}
