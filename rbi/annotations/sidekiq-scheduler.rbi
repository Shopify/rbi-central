# typed: strong

class SidekiqScheduler::Scheduler
  # @missing_method: Delegated to `instance`
  sig { void }
  def self.reload_schedule!; end

  # @missing_method: Delegated to `instance`
  sig { params(_arg0: T.nilable(T::Boolean)).returns(T.nilable(T::Boolean)) }
  def self.listened_queues_only=(_arg0); end
end
