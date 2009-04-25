module Wegasoo
    class Task # inherit this class
        class << self; alias [] new; end
        def initialize
            raise 'you can not run the Task class! it has no action!'
        end
        # number of subTasks to be run (default 0)
        def subtask_count
            return 0
        end
        # for example: "taking out the garbage"
        def title
            return "running the example"
        end
        # possible yield values:
        #   :verbose_text => String # if the user enabled verbose text, display the String
        #   :warning_text => String # if the user enabled warnings, display the String
        #   :fail => String # fail with the reason, #raise has the same effect
        #   :subtask => Task # run the subtask (Task) and increase the number of subtasks run
        #   :command => String # output the command as verbose text and run it (recommended over #system)
        def run
            raise 'no block given' unless block_given?
            yield :fail => "the task maker hasn't implemented #run"
        end
    end
end
