desc "Check for Puppet template syntax errors"
task :syntax_erb do
  require 'erb'
  require 'stringio'

  $stderr.puts '---> Checking Puppet template syntax'

  # We now have to redirect STDERR in order to capture warnings.
  $stderr = warnings = StringIO.new()
  errors = []

  # get_modules() may or may not return a trailing asterisk.
  # Templates don't have to have a .erb extension
  matched_files = FileList[*get_modules.map { |x| x.chomp('/*') + '/*/templates/**/*' }]
  matched_files.reject! { |f| File.directory?(f) }
  matched_files.each do |erb_file|
    begin
      erb = ERB.new(File.read(erb_file), nil, '-')
      erb.filename = erb_file
      erb.result
    rescue NameError
      # This is normal because we don't have the variables that would
      # ordinarily be bound by the parent Puppet manifest.
    rescue StandardError, SyntaxError => error
      errors << error
    end
  end

  $stderr = STDERR
  errors << warnings.string unless warnings.string.empty?
  fail errors.join("\n") unless errors.empty?
end
