require_relative "eval_func"

class Environment
  attr_reader :env

  # env == list of hash
  # [{:+: AddOp}]
  def initialize(env=[])
    @env = env
  end

  def lookup_var(var)
    target_env = @env.find{|e| e.key?(var)}
    if target_env.nil?
      raise "couldn't find value to variables:'#{var}'"
    end
    target_env[var]
  end

  def extend(env)
     Environment.new([env] + @env)
  end
end

