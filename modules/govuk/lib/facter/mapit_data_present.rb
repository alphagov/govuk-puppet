# Facter fact to check if a mapit node needs to import the database of postcodes
# It does this by running an psql query that checks for the same postcode as the
# health check.

Facter.add("mapit_data_present") do
  setcode do
    Facter::Core::Execution.execute("sudo -u postgres psql -qAt mapit -c \"select count(*) from mapit_postcode WHERE postcode = 'SW1A1AA'\" 2>/dev/null")
  end
end
