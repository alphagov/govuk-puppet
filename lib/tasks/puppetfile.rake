desc "Test Puppetfile URLs"
task :puppetfile do
  # Use anonymous `git://` URLs because they don't require authentication or
  # distributing the host key.
  $stderr.puts "---> Checking Puppetfile URLs"

  %w{Puppetfile Puppetfile.lock}.each do |file_name|
    File.readlines(file_name).each do |file_line|
      if file_line =~ /git@github|ssh:\/\//
        fail "#{file_name} must not contain SSH URLs. Please convert to `git://`"
      end
    end
  end
end
