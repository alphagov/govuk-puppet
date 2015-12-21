# Boolean fact which is true if node is part of the
# DR cluster

def dr_node?
  env_octet = Facter.value(:ipaddress).split('.')[2].to_i
  if env_octet > 7
    dr = true
  else
    dr = false
  end

  dr
end

Facter.add("dr_node") do
  setcode do
   dr_node?
  end
end
