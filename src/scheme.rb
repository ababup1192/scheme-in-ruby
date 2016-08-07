require_relative 'eval_func'
require_relative 'environment'

class Interpreter
  attr_reader :env, :exp

  def initialize(exp)
    @env = Environment.new()
    @exp = exp
    @exp.add_env(@env)
  end

  def eval
    @exp.eval
  end
end

