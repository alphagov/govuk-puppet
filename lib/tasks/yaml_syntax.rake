# Note that this task is not intended for Hiera YAML files,
# which are already checked by the puppet-syntax gem:
# https://github.com/gds-operations/puppet-syntax/blob/49f7d4d1125cd9c671511fe3e727ff4c2f38fb04/lib/puppet-syntax/hiera.rb
#
# Rather, this is intended to check YAML contained in files
# or templates that we use in our Puppet modules.
require 'erb'
require 'yaml'

def lint_yaml_file(file)
  begin
    YAML.load_file(file)
  rescue Exception => e
    return e
  end

  return
end

desc "Syntax-check YAML files"
task :yaml_syntax do
  $stderr.puts '---> Checking YAML file syntax'
  errors = []

  templates = FileList["**/templates/**/*.y{a,}ml*"]
  templates.reject! { |f| File.directory?(f) }
  templates = templates.exclude(*PuppetSyntax.exclude_paths)

  templates.each do |erb_file|
    begin
      erb = ERB.new(File.read(erb_file), nil, '-')

      Tempfile.open("puppet_yaml_lint") do |temp_file|
        temp_file << erb.result
        temp_file.close

        result = lint_yaml_file(temp_file.path)
        if result
          errors << "#{erb_file}:"
          errors << result
        end
      end
    rescue NameError, TypeError, SyntaxError => error
      # Ignore ERB rendering errors, these will be picked up by puppet-syntax
    end
  end

  files = FileList["**/files/**/*.y{a,}ml"] + FileList["hieradata/**/*.y{a,}ml"]
  files.reject! { |f| File.directory?(f) }
  files = files.exclude(*PuppetSyntax.exclude_paths)

  files.each do |file|
    errors << lint_yaml_file(file)
  end

  fail errors.join("\n") if errors.any?
end
