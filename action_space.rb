require 'yaml'
require 'action'
module Wegasoo
    class ActionSpace
        def initialize
            @actions = []
        end
        def load_file(path)
            y = YAML.load_file(path)
            prfx = []
            prc = proc do |n,a|
                case a
                when Hash
                    prfx << n
                    a.each &prc
                    prfx.delete_at -1
                when String
                    @actions << Action.new((prfx+[n]).join(':'), a)
                end
            end
            y.each &prc
            true
        end
        def run(tn, level=0)
            if (act = @actions.find{|act|act.name==tn})
                act.run(level)
            else
                Formatting.failure(level, "action not found")
            end
        end
    end
end
