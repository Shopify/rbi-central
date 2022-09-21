# typed: strong

class SidekiqScheduler::Scheduler
  # @shim: Instance methods are made to function as class methods using `method_missing`
  sig { void }
  def self.reload_schedule!; end

  # @shim: Instance methods are made to function as class methods using `method_missing`
  sig { params(_arg0: T.nilable(T::Boolean)).returns(T.nilable(T::Boolean)) }
  def self.listened_queues_only=(_arg0); end
end
