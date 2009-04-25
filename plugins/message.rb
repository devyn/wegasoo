class WGS_Message < Wegasoo::Task
    def initialize(title, message)
        @t   = title
        @msg = message
    end
    def title
        return @t.it
    end
    def run
        raise 'no block given' unless block_given?
        @msg.it.each_line do |ln|
            yield :verbose_text => ln.chomp
        end
    end
end

