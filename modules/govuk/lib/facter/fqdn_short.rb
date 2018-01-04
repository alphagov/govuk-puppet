# Facter fact that provides a shorter machine name

Facter.add("fqdn_short") do
  setcode do
    fqdn_short = Facter.value("fqdn").dup
    if Facter.value(:aws_migration)
      fqdn_short.gsub(/\..*/, '')
    else
      fqdn_short.gsub!(/\.publishing\.service\.gov\.uk$/, '')
    end

    fqdn_short
  end
end
