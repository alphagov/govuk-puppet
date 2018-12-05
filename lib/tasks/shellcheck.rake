namespace :shell do
  desc "Run Shellcheck against shell scripts; optional commit range confines checks to scripts that have changed."

  task :shellcheck, [:commit1, :commit2] do |task, args|
    if args[:commit1] and args[:commit2]
      out, status = Open3.capture2('git', 'diff', '--name-status', args[:commit1], args[:commit2], '--', '**/*.sh')
      if status.success?
        files = []
        out.split("\n").each do |line|
          status, filename = line.split("\t")
          if ['M','A'].include?(status) then
            files << filename
          end
        end
      else
        fail "git diff exited with status #{status}. Output:\n\n#{out}"
      end

    else
      files = FileList.new('**/*.sh').to_ary
    end

    if files.length > 0 then
      shellcheck_cmd = ['shellcheck', '-e', 'SC2034', files].flatten
      fail if not system(*shellcheck_cmd)
    end
  end
end
