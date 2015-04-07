require "string"
require "math"
require "table"

local status_codes = {}
local request_times = {}

local ticker_interval = read_config("ticker_interval") or error("must provide ticker_interval")
local percent_thresh = read_config("percent_threshold") or 90

function process_message()
    local hostname = read_message("Hostname")
    local logger = read_message("Logger")
    local status = read_message("Fields[status]")
    local request_time = read_message("Fields[request_time]")

    local bucket = string.format("%s.nginx.%s.http_%d", hostname, logger, status)
    local val = status_codes[bucket] or 0
    status_codes[bucket] = val + 1

    bucket = string.format("%s.nginx.%s.request_time", hostname, logger)
    val = request_times[bucket] or {}
    val[#val+1] = request_time
    request_times[bucket] = val
    return 0
end

function timer_event(ns)
    local now_sec = math.floor(ns / 1e9)
    local rate
    local num_stats = 0
    for bucket, count in pairs(status_codes) do
        rate = count / ticker_interval
        add_to_payload(string.format("stats.counters.%s.count %d %d\n", bucket, count, now_sec))
        add_to_payload(string.format("stats.counters.%s.rate %f %d\n", bucket, rate, now_sec))
        status_codes[bucket] = 0
        num_stats = num_stats + 1
    end

    local count, min, max, sum, mean, rate, mean_percentile, upper_percentile
    local cumulative, tmp
    for bucket, times in pairs(request_times) do
        count = #times
        if count == 0 then
            min = 0
            max = 0
            sum = 0
            mean = 0
            rate = 0
            mean_percentile = 0
            upper_percentile = 0
        else
            rate = count / ticker_interval
            table.sort(times)
            min = times[1]
            max = times[count]
            mean = min
            thresh_bound = max

            cumulative = {}
            cumulative[0] = 0
            for i, time in ipairs(times) do
                cumulative[i] = cumulative[i-1] + time
            end

            if count > 1 then
                tmp = ((100 - percent_thresh) / 100) * count
                num_in_thresh = count - math.floor(tmp+.5)
                if num_in_thresh > 0 then
                    mean = cumulative[num_in_thresh] / num_in_thresh
                    thresh_bound = times[num_in_thresh]
                else
                    mean = min
                    thresh_bound = max
                end
            end
            mean_percentile = mean
            upper_percentile = thresh_bound
            sum = cumulative[count]
            mean = sum / count
        end

        add_to_payload(string.format("stats.timers.%s.count %d %d\n", bucket, count, now_sec))
        add_to_payload(string.format("stats.timers.%s.count_ps %f %d\n", bucket, rate, now_sec))
        add_to_payload(string.format("stats.timers.%s.lower %f %d\n", bucket, min, now_sec))
        add_to_payload(string.format("stats.timers.%s.upper %f %d\n", bucket, max, now_sec))
        add_to_payload(string.format("stats.timers.%s.sum %f %d\n", bucket, sum, now_sec))
        add_to_payload(string.format("stats.timers.%s.mean %f %d\n", bucket, mean, now_sec))
        add_to_payload(string.format("stats.timers.%s.mean_%d %f %d\n", bucket, percent_thresh,
            mean_percentile, now_sec))
        add_to_payload(string.format("stats.timers.%s.upper_%d %f %d\n", bucket, percent_thresh,
            upper_percentile, now_sec))
        num_stats = num_stats + 1
        request_times[bucket] = {}
    end

    add_to_payload(string.format("stats.statsd.numStats %d %d\n", num_stats, now_sec))
    inject_payload("txt", "statmetric")
end
