desc "Check for Puppet manifest syntax errors"
task :syntax_pp do
  require 'puppet/face'

  def validate_manifest(file)
    Puppet::Face[:parser, '0.0.1'].validate(file)
  end

  $stderr.puts '---> Checking Puppet manifest syntax'

  errors = []
  matched_files = FileList[*get_modules.map { |x| "#{x}/**/*.pp" }]
  matched_files.each do |puppet_file|
    begin
      validate_manifest(puppet_file)
    rescue => error
      errors << error
    end
  end

  fail errors.join("\n") unless errors.empty?
end
