require 'puppet-lint'

PuppetLint.configuration.with_filename = true
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_double_quoted_strings")

# FIXME: this is disabled not because it's a bad idea for a check, but because
# we have a temporary workaround in place for the UFW module (see 6b0f870)
# which triggers this error. When this workaround is removed, please remove
# this line too.
PuppetLint.configuration.send("disable_inherits_across_namespaces")

# puppet-lint has got a lot stricter (but a lot faster) recently. I'm
# temporarily disabling the following checks but will bring them back bit by
# bit.
PuppetLint.configuration.send("disable_documentation")
PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_class_parameter_defaults")

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
