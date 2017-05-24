require 'erb'
require 'open3'

def check_bash_script(file)
  errors = []

  output, status = Open3.capture2e("bash -n #{file}")
  unless output.empty?
    errors << "#{file}:"
    errors << output
  end

  errors
end

BASH_HEADER = /#!.*bash/

desc "Syntax-check Bash scripts"
task :bash_syntax do
  $stderr.puts '---> Checking Bash script syntax'
  errors = []

  templates = FileList["**/templates/**/*"]
  templates.reject! { |f| File.directory?(f) }
  templates = templates.exclude(*PuppetSyntax.exclude_paths)

  templates.each do |erb_file|
    next unless File.open(erb_file).gets =~ BASH_HEADER

    begin
      erb = ERB.new(File.read(erb_file), nil, '-')

      Tempfile.open("puppet_bash_check") do |temp_file|
        temp_file << erb.result
        temp_file.close

        result = check_bash_script(temp_file.path)

        if result.any?
          errors << "#{erb_file}:"
          errors << result
        end
      end
    rescue NameError, TypeError, SyntaxError => error
      # Ignore ERB rendering errors, these will be picked up by puppet-syntax
    end
  end

  files = FileList["**/files/**/*"]
  files.reject! { |f| File.directory?(f) }
  files = files.exclude(*PuppetSyntax.exclude_paths)

  files.each do |file|
      if File.open(file, 'rb').read() =~ BASH_HEADER
        errors.concat(check_bash_script(file))
      end
  end

  fail errors.join("\n") if errors.any?
end
