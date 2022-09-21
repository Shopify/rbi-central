# typed: strong

class SidekiqScheduler::Scheduler
  sig { void }
  def self.reload_schedule!; end

  sig { params(_arg0: T.nilable(T::Boolean)).returns(T.nilable(T::Boolean)) }
  def self.listened_queues_only=(_arg0); end
end
