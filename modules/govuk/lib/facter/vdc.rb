# Fact which specifies the name of the vDC of a node

Facter.add("vdc") do
  setcode do
    env_octet = Facter.value(:ipaddress).split('.')[2].to_i
    vdc = Facter.value(:domain).split('.').first
    if env_octet > 7
      vdc + '_dr'
    else
      vdc
    end
  end
end
