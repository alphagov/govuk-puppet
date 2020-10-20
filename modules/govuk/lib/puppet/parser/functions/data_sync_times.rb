module Puppet::Parser::Functions
  newfunction(:data_sync_times, :type => :rvalue, :doc => <<-EOS
Return information about the data sync times, depending on the argument passed
    EOS
  ) do |args|
    start_hour = 22
    start_minute = 0
    finish_hour = 8
	finish_minute = 0
	expected_args = 1

    if args.size != expected_args
      raise ArgumentError, "data_sync_times: Wrong number of arguments " +
      "(given #{args.size}, expected #{expected_args})"
    end

    type = args[0]

    case type
    when 'time_range'
      "#{start_hour}:#{start_minute}-#{finish_hour}:#{finish_minute}"
    when 'start_time'
      "#{start_hour}:#{start_minute}"
    when 'start_hour'
      start_hour
    when 'start_minute'
      start_minute
    when 'finish_time'
      "#{finish_hour}:#{finish_minute}"
    when 'finish_hour'
      finish_hour
    when 'finish_minute'
      finish_minute
    else
      raise ArgumentError, "data_sync_times: Unknown argument #{type}"
    end
  end
end
