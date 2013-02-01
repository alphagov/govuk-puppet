require 'facter'
# A fact that is equal to the memory in MB
Facter.add("memtotalmb") do
    confine :kernel => :linux
    ram = 0
    File.open( "/proc/meminfo" , 'r' ) do |f|
        f.grep( /^MemTotal:/ ) { |mem|
            ram = mem.split( / +/ )[1].to_i / 1024
        }
    end
    setcode do
        ram
    end
end
