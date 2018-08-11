export localips

const port = Ref{Int}()

@init port[] = haskey(ENV, "BLINK_PORT") ? parse(Int, get(ENV, "BLINK_PORT")) : rand(2_000:10_000)

const ippat = r"([0-9]+\.){3}[0-9]+"

@static if isunix()
    localips() = map(IPv4, readlines(`ifconfig` |>
                      `grep -Eo $("inet (addr:)?$(ippat.pattern)")` |>
                      `grep -Eo $(ippat.pattern)` |>
                      `grep -v $("127.0.0.1")`))
end

# Browser Window

@static if isapple()
    launch(x) = run(`open $x`)
elseif islinux()
    launch(x) = run(`xdg-open $x`)
elseif iswindows()
    launch(x) = run(`cmd /C start $x`)
end

localurl(p::Page) = "http://127.0.0.1:$(port[])/$(id(p))"

launch(p::Page) = (launch(localurl(p)); p)
