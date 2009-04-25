require 'fileutils'

class WGS_Clean < Wegasoo::Task
    class SingleFile < Wegasoo::Task
        def initialize(file)
            @file = file
        end
        def title
            @file = @file.it
            return "deleting #@file"
        end
        def run
            raise 'no block given' unless block_given?
            FileUtils.rm_f @file
        end
    end
    def initialize(*files)
        @files = files
    end
    def subtask_count
        @files.size
    end
    def title
        return "cleaning up"
    end
    def run
        raise 'no block given' unless block_given?
        @files.each do |f|
            yield :subtask => SingleFile[f]
        end
    end
end
