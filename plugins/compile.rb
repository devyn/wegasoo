class WGS_Compile < Wegasoo::Task
    def initialize(file, options='')
        @file = file
        @options = options
    end
    def title
        @file = @file.it
        @file =~ /\.(.+)$/; @type = $1
        @file =~ /^(.*)\..+$/; @base = File.basename($1)
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
        when 'nqc'
            return "downloading NQC code: #{File.basename(@file)}"
        else
            return "???"
        end
    end
    def run
        raise 'no block given' unless block_given?
        case @type
        when 'c'
            yield :command => "gcc #{@options.it} -o #@base #@file"
        when 'cc', 'cpp', 'c++'
            yield :command => "g++ #{@options.it} -o #@base #@file"
        when 'erl'
            yield :command => "erl #{@options.it} -compile #@base"
        when 'rb'
            yield :command => "ruby #{@options.it} -c #@file"
        when 'py'
            yield :command => "python #{@options.it} -c \"import #@base as theCompiledResult\"" # any better ways to generate the python bytecode?
        when 'nqc'
            yield :command => "nqc #{@options.it} -d #@file"
        end
    end
end
