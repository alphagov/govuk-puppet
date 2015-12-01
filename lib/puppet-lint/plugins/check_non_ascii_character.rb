PuppetLint.new_check(:non_ascii_comments) do
  def check
    tokens.select { |token|
      token.type == :COMMENT
    }.each do |token|
      if token.value.match(/[^[:ascii:]]/)
        notify :error, {
          :message => 'Non-ASCII character found in comment',
          :line    => token.line,
          :column  => token.column,
        }
      end
    end
  end
end
