desc "Check if the monitoring_docs_url's in puppet definitions link to an existing page"
task :lint_alert_docs do
  checks = Dir.glob("modules/**/*.pp").map do |filename|
    code = File.read(filename)
    code.scan(%r[monitoring_docs_url\((.*)\)]).to_a
  end.flatten.compact.uniq

  puts "ICINGA ALERTS NOT IN DOCS"

  checks.each do |check|
    next if check == "$healthcheck_opsmanual"
    unless File.exist?("../docs.publishing.service.gov.uk/source/manual/alerts/#{check}.html.md")
      puts "NOT FOUND: #{check}"
    end
  end

  puts "\n\nDOCS NOT LINKED FROM ICINGA"

  Dir.glob("../docs.publishing.service.gov.uk/source/manual/alerts/*.md").each do |filename|
    name = File.basename(filename).sub('.html.md', '')
    next if name.end_with?('healthcheck-not-ok')

    unless checks.include?(name)
      puts "NOT FOUND: #{name}"
    end
  end
end
