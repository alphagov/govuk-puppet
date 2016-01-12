# Facter fact that provides a shorter machine name

Facter.add("fqdn_short") do
  setcode do
    fqdn_short = Facter.value("fqdn").dup
    fqdn_short.gsub!(/\.publishing\.service\.gov\.uk$/, '')

    fqdn_short
  end
end
