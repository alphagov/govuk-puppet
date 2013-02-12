def dhcp_enabled?
  ifs = '/etc/network/interfaces'
  dhcp = 'false'

  if FileTest.exists?(ifs) and File.read('/etc/network/interfaces') =~ /inet\s+dhcp/
    dhcp = 'true'
  end

  dhcp
end

Facter.add("dhcp_enabled") do
  confine :osfamily => 'Debian'
  setcode do
    dhcp_enabled?
  end
end
