# Fact which specifies the name of the vDC of a node

Facter.add("vdc") do
  setcode do
    Facter.value(:domain).split('.').first
  end
end
