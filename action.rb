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
            @str = str
            @builder = builder
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
                    exit 1
                when :subtask
                    @cn += 1
                    ret.values[0].run(&fmb(ret.values[0].title,sp+1)) # remember the raise!
                when :command
                    Formatting.command(sp,ret.values[0])
                    IO.popen(ret.values[0]+" 2>&1", 'r') do |p|
                        p.each_line do |ln|
                            Formatting.command_text(sp,ln.chomp)
                        end
                    end
                    # system(ret.values[0]) or raise("command exited with abnormal status: #{$?.exitstatus}") # in the future, should use something like Open3.popen3
                end
            end
        end
        def run(level=0)
            begin
                # load the task
                instance_eval @str if @str
                instance_eval &@builder if @builder
                # done loading, continue...
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
            rescue Exception
                Formatting.failure level, $!.message
                exit 1
            end
        end
    end
end
