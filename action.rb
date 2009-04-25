require 'task'
require 'formatting'

module Wegasoo
    class Action
        attr :name
        def initialize(_name, str=nil, level=0, &builder)
            @name = _name
            @dependencies = []
            @tasks = []
            @tcn = 0
            raise 'no str or builder passed' unless str or builder
            instance_eval str if str
            instance_eval &builder if builder
        end
        def <<(task)
            @tasks << task
            @tcn += 1+task.subtask_count
        end
        def dependency(dep)
            @tcn += 1
            @dependencies << dep
        end
        def fmb(tt,sp)
            Formatting.task(@cn,@tcn,sp,tt)
            proc do |ret|
                case ret.keys[0]
                when :verbose_text
                    Formatting.verbose(sp,ret.values[0])
                when :warning_text
                    Formatting.warning(sp,ret.values[0])
                when :fail
                    Formatting.failure(sp,ret.values[0])
                    abort
                when :subtask
                    @cn += 1
                    ret.values[0].run(&fmb(ret.values[0].title,sp+1)) # remember the raise!
                when :command
                    Formatting.command(sp,ret.values[0])
                    system ret.values[0] # in the future, should use something like Open3.popen3
                end
            end
        end
        def run(level=0)
            @cn = 0
            @dependencies.each do |d|
                @cn += 1
                Formatting.dependency(@cn,@tcn,level,d)
                $was.run d, level+1
            end
            @tasks.each do |t|
                @cn += 1
                t.run &fmb(t.title,level)
            end
        end
    end
end
