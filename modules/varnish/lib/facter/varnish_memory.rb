require 'facter'
# A fact that is equal to 75% of the memory in MB
Facter.add("varnish_cachesize_mb") do
    confine :kernel => :linux
    ram = 0
    File.open( "/proc/meminfo" , 'r' ) do |f|
        f.grep( /^MemTotal:/ ) { |mem|
            # memory in gigabytes
            ram = mem.split( / +/ )[1].to_i / 1024 * 3 / 4
        }
    end
    setcode do
        ram
    end
end
