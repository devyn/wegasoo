class WGS_Compile < Wegasoo::Task
    def initialize(file)
        @file = file
    end
    def title
        case @type
        when 'c'
            return "compiling C object: #{File.basename(@file)}"
        when 'cc', 'cpp', 'c++'
            return "compiling C++ object: #{File.basename(@file)}"
        when 'erl'
            return "compiling BEAM object: #{File.basename(@file)}"
        when 'rb'
            return "checking Ruby syntax: #{File.basename(@file)}"
        when 'py'
            return "compiling Python module: #{File.basename(@file)}"
        end
    end
    def run
        raise 'no block given' unless block_given?
        @file = @file.it
        @file =~ /\.(.+)$/; @type = $1
        @file =~ /^(.*)\..+$/; @base = File.basename($1)
        case @type
        when 'c'
            yield :command => "gcc -o #@base #@file"
        when 'cc', 'cpp', 'c++'
            yield :command => "g++ -o #@base #@file"
        when 'erl'
            yield :command => "erl -compile #@base"
        when 'rb'
            yield :command => "ruby -c #@file"
        when 'py'
            yield :command => "python -c \"import #@base as theCompiledResult\"" # any better ways to generate the python bytecode?
        end
    end
end
