require 'puppet-lint'

# Load custom checks.
FileList['lib/puppet-lint/plugins/*.rb'].each do |plugin|
  load plugin
end

PuppetLint.configuration.with_filename = true
PuppetLint.configuration.send("disable_140chars")

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
    linter.print_problems
  end
  fail if linter.errors? or linter.warnings?
end
