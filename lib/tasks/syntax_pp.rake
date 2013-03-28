desc "Check for Puppet manifest syntax errors"
task :syntax_pp do
  require 'puppet'
  require 'puppet/face'

  def validate_manifest(file)
    Puppet::Face[:parser, '0.0.1'].validate(file)
  end

  $stderr.puts '---> Checking Puppet manifest syntax'
  errors = []

  # Catch syntax warnings.
  Puppet::Util::Log.newdestination(Puppet::Test::LogCollector.new(errors))
  Puppet::Util::Log.level = :warning

  matched_files = FileList[*get_modules.map { |x| "#{x}/**/*.pp" }]
  matched_files.each do |puppet_file|
    begin
      validate_manifest(puppet_file)
    rescue => error
      errors << error
    end
  end

  # Exported resources will raise warnings when outside a puppetmaster.
  Puppet::Util::Log.close_all
  errors.reject! { |e|
    e.to_s =~ /^You cannot collect( exported resources)? without storeconfigs being set/
  }

  fail errors.join("\n") unless errors.empty?
end
