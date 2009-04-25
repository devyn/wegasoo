module Wegasoo
    module Formatting
        extend self
        SETTINGS = {:verbose=>true,:warnings=>true,:silent=>false}
        SETTINGS.update(eval(ENV['WEGASOO_FORMATTING']||'{}'))
        def puts(text)
            Kernel.puts text unless SETTINGS[:silent]
        end
        def warn(text)
            Kernel.warn text unless SETTINGS[:silent]
        end
        def space(num); (num==0 ? ' ' : "\t"); end
        def special text
            puts "!  \e[1m\e[32m#{text}\e[0m"
        end
        def task numerator, denominator, spacing, text
            puts ">>#{space(spacing)}\e[32m(\e[1m#{numerator}\e[22m/\e[1m#{denominator}\e[22m)\e[0m \e[36m\e[1m#{text}\e[0m"
        end
        def verbose spacing, text
            puts ">>\t#{space(spacing)}#{text}" if SETTINGS[:verbose]
        end
        def warning spacing, text
            warn ">>\t#{space(spacing)}\e[33m#{text}\e[0m" if SETTINGS[:warnings]
        end
        def failure spacing, text
            warn ">>\t#{space(spacing)}\e[31m\e[1m#{text}\e[0m"
        end
        def command spacing, text
            puts ">>\t#{space(spacing)}\e[34m\e[1m#{text}\e[0m"
        end
        def command_text spacing, text
            puts ">>\t\t#{space(spacing)}\e[34m#{text}\e[0m" if SETTINGS[:verbose]
        end
        def dependency numerator, denominator, spacing, text
            puts ">>#{space(spacing)}\e[32m(\e[1m#{numerator}\e[22m/\e[1m#{denominator}\e[22m)\e[0m \e[35m\e[1m#{text}\e[0m"
        end
    end
end

