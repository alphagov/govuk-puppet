require 'rspec/core/rake_task'
require 'puppet-lint'
require 'parallel_tests'
require 'parallel_tests/cli'

ENV['RUBYOPT'] = (ENV['RUBYOPT'] || '') + ' -W0'

THIRD_PARTY_MODULES = %w[
  concat
  kwalify
]

PuppetLint.configuration.with_filename = true
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_double_quoted_strings")

# puppet-lint has got a lot stricter (but a lot faster) recently. I'm
# temporarily disabling the following checks but will bring them back bit by
# bit.
PuppetLint.configuration.send("disable_documentation")
PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_variables_not_enclosed")
PuppetLint.configuration.send("disable_class_parameter_defaults")

def get_modules
  if ENV['mods']
    ENV['mods'].split(',').map { |x| x == 'manifests' ? x : "modules/#{x}" }
  else
    ['manifests', 'modules/*']
  end
end

desc "Run puppet-lint on one or more modules"
task :lint do
  manifests_to_lint = FileList[*get_modules.map { |x| "#{x}/**/*.pp" }]
  linter = PuppetLint.new

  if ignore_paths = PuppetLint.configuration.ignore_paths
    manifests_to_lint = manifests_to_lint.exclude(*ignore_paths)
  end

  $stderr.puts '---> Running lint checks'

  manifests_to_lint.each do |puppet_file|
    linter.file = puppet_file
    linter.run
  end

  fail if linter.errors? or linter.warnings?
end

desc "Run rspec"
task :spec do
  matched_files = FileList[*get_modules.map { |x| "#{x}/spec/**/*_spec.rb" }]

  matched_files = matched_files.exclude(*THIRD_PARTY_MODULES.map { |x| "modules/#{x}/**/*" })

  cli_args = ['-t', 'rspec']
  cli_args.concat(matched_files)

  $stderr.puts '---> Running puppet specs (parallel)'
  ParallelTest::CLI.run(cli_args)
end

desc "Run custom module rake tasks"
task :custom do
  custom_rakefiles = FileList[*get_modules.map { |x| "modules/#{x}/Rakefile" }]
  custom_rakefiles.select! { |x| File.exist?(x) }

  # Until we remove these from this repository, exclude third party modules.
  custom_rakefiles = custom_rakefiles.exclude(*THIRD_PARTY_MODULES.map { |x| "modules/#{x}/**/*" })

  custom_rakefiles.each do |fn|
    name = File.dirname(fn)
    Dir.chdir(name) do
      $stderr.puts "---> Running custom tests for #{name}"
      namespace name do
        instance_eval File.read('Rakefile')
        Rake::Task["#{name}:default"].invoke
      end
    end
  end
end

desc "Test nagios::checks are unique per machine"
task :nagios_checks do
  $stderr.puts '---> Checking nagios::check titles are sufficiently unique'
  bad_lines = %x{find ./modules -path ./modules/nagios -prune -or -name '*.pp' -print0 | xargs -0 grep -nF nagios::check | grep -vF hostname}
  if !bad_lines.empty? then
    $stderr.puts bad_lines
    fail 'ERROR: nagios::check resource titles should be unique per machine. Normally you can achieve this by adding ${::hostname} eg "check_widgets_${::hostname}".'
  end
end

desc "Run all tests"
task :test => [:spec, :nagios_checks, :custom]

task :default => [:lint, :test]
