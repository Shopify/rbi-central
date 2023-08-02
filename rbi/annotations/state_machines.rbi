# typed: true

class StateMachines::Machine
  include StateMachines::MatcherHelpers
  include StateMachines::EvalHelpers

  sig { params(name: T.any(Symbol, String), blk: T.nilable(T.proc.bind(T.untyped).void)).void }
  def state(*name, &blk); end
end

class StateMachines::Event
  include StateMachines::MatcherHelpers

  sig { params(states: T::Hash[ T.any(String, Symbol, T::Array[T.any(String, Symbol)]), T.any(String, Symbol)]).void }
  def transition(states); end
end

module StateMachines::MatcherHelpers
  sig { returns(StateMachines::AllMatcher) }
  def all; end

  sig { returns(StateMachines::AllMatcher) }
  def any; end

  sig { returns(StateMachines::LoopbackMatcher) }
  def same; end
end
