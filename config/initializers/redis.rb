# https://github.com/resque/redis-namespace/pull/171#issuecomment-670917998
if Redis::Namespace::NAMESPACED_COMMANDS.key?("exists?")
  raise "Redis::Namespace now supports variadac exists, you can remove below workaround!"
end

class Redis::Namespace
  MY_HACKY_COMMANDS = {
    "exists" => [:all],
    "exists?" => [:all]
  }
  NAMESPACED_COMMANDS.reverse_merge!(MY_HACKY_COMMANDS)
  COMMANDS.reverse_merge!(MY_HACKY_COMMANDS)

  MY_HACKY_COMMANDS.keys.each do |command|
    next if method_defined?(command)

    define_method(command) do |*args, &block|
      call_with_namespace(command, *args, &block)
    end
  end
end
