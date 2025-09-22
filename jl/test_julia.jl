using Dates

open(ARGS[1], "w") do arch
    print(arch, Dates.format(Dates.now(), "YYYYmmdd HHMMSS\n"))
end

