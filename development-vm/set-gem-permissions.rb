#!/usr/bin/env ruby -w

gems = %w{govspeak gds-provisioner gds-api-adapters plek slimmer gds-sso}

owners = {
  "jystewart@gmail.com" => "James Stewart",
  "jordan@jordanh.net" => "Jordan Hatch",
  "gareth@morethanseven.net" => "Gareth Rushgrove",
  "david@davidheath.org" => "David Heath",
  "alex@tomlins.org.uk" => "Alex Tomlins",
  "dai+gems@daibach.co.uk" => "Dafydd Vaughan",
  "mail@fatbusinessman.com" => "David Thompson",
  "mat.wall@digital.cabinet-office.gov.uk" => "Mat Wall"
}

def remove_owners(gemname, emails)
  emails.each do |email|
    output = `gem owner -r "#{email}" "#{gemname}"`
    raise "ERROR: #{output}" unless $?.success?
    puts "#{gemname}: removed #{email} as owner" if $?.success?
  end
end

def add_owners(gemname, emails)
  emails.each do |email|
    output = `gem owner -a "#{email}" "#{gemname}"`
    raise "ERROR: #{output}" unless $?.success?
    puts "#{gemname}: added #{email} as owner" if $?.success?
  end
end

gems.each do |gemname|
  current_owners = (`gem owner #{gemname} | grep '^- ' | sed 's/^- //'`).split "\n"
  add_owners(gemname, owners.keys - current_owners)

  # leave this commented out until we're sure everyone who cares
  # has added their details
  # remove_owners(current_owners - owners.keys)
end
