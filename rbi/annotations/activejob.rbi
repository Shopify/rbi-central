# typed: true

class ActiveJob::Base
  sig { params(blk: T.proc.bind(T.attached_class).params(job: T.attached_class, exception: Exception).void).void }
  def self.after_discard(&blk); end

  sig do
    params(filters: T.untyped, blk: T.nilable(T.proc.bind(T.attached_class).params(job: T.attached_class).void)).void
  end
  def self.after_enqueue(*filters, &blk); end

  sig do
    params(filters: T.untyped, blk: T.nilable(T.proc.bind(T.attached_class).params(job: T.attached_class).void)).void
  end
  def self.after_perform(*filters, &blk); end

  sig do
    params(
      filters: T.untyped,
      blk: T.nilable(T.proc.bind(T.attached_class).params(job: T.attached_class, block: T.untyped).void)
    ).void
  end
  def self.around_enqueue(*filters, &blk); end

  sig do
    params(
      filters: T.untyped,
      blk: T.nilable(T.proc.bind(T.attached_class).params(job: T.attached_class, block: T.untyped).void)
    ).void
  end
  def self.around_perform(*filters, &blk); end

  sig do
    params(filters: T.untyped, blk: T.nilable(T.proc.bind(T.attached_class).params(job: T.attached_class).void)).void
  end
  def self.before_enqueue(*filters, &blk); end

  sig do
    params(filters: T.untyped, blk: T.nilable(T.proc.bind(T.attached_class).params(job: T.attached_class).void)).void
  end
  def self.before_perform(*filters, &blk); end

  sig do
    type_parameters(:ExceptionType)
      .params(
        exceptions: T::Class[T.type_parameter(:ExceptionType)],
        block: T.nilable(T.proc.params(job: T.attached_class, error: T.type_parameter(:ExceptionType)).void)
      ).void
  end
  sig do
    params(exceptions: T.any(Module, String), block: T.nilable(T.proc.params(job: T.attached_class, error: T.untyped).void)).void
  end
  def self.discard_on(*exceptions, &block); end

  sig do
    params(
      klasses: T.any(Module, String),
      with: T.nilable(Symbol),
      block: T.nilable(T.proc.params(exception: T.untyped).void)
    ).void
  end
  def self.rescue_from(*klasses, with: nil, &block); end

  sig do
    params(
      exceptions: T.any(Module, String),
      wait: T.any(ActiveSupport::Duration, Integer, Symbol, T.proc.params(executions: Integer).returns(Integer)),
      attempts: T.any(Integer, Symbol),
      queue: T.nilable(T.any(String, Symbol)),
      priority: T.untyped,
      jitter: Numeric,
      block: T.nilable(T.proc.params(job: T.attached_class, error: T.untyped).void)
    ).void
  end
  def self.retry_on(*exceptions, wait: 3.seconds, attempts: 5, queue: nil, priority: nil, jitter: ActiveJob::Exceptions::JITTER_DEFAULT, &block); end

  sig { params(part_name: T.nilable(T.any(String, Symbol)), block: T.nilable(T.proc.bind(T.attached_class).returns(T.untyped))).void }
  def self.queue_as(part_name = nil, &block); end

  sig { params(priority: T.untyped, block: T.nilable(T.proc.bind(T.attached_class).returns(T.untyped))).void }
  def self.queue_with_priority(priority = nil, &block); end
end

# @version >= 8.1.0.beta1
module ActiveJob::Continuable
  sig do
    params(
      step_name: Symbol,
      start: T.untyped,
      isolated: T::Boolean,
      block: T.nilable(T.proc.params(step: ActiveJob::Continuation::Step).void),
    ).void
  end
  def step(step_name, start: nil, isolated: false, &block); end
end

module ActiveJob::TestHelper
  # @version < 8.2.0
  sig do
    params(
      number: Integer,
      only: T.untyped,
      except: T.untyped,
      queue: T.nilable(T.any(String, Symbol)),
      block: T.nilable(T.proc.void)
    ).returns(TrueClass)
  end
  def assert_enqueued_jobs(number, only: nil, except: nil, queue: nil, &block); end

  # @version >= 8.2.0
  sig do
    type_parameters(:Block)
      .params(
        number: Integer,
        only: T.untyped,
        except: T.untyped,
        queue: T.nilable(T.any(String, Symbol)),
        block: T.proc.returns(T.type_parameter(:Block))
      ).returns(T.type_parameter(:Block))
  end
  sig { params(number: Integer, only: T.untyped, except: T.untyped, queue: T.nilable(T.any(String, Symbol))).returns(TrueClass) }
  def assert_enqueued_jobs(number, only: nil, except: nil, queue: nil, &block); end

  # @version < 8.2.0
  sig do
    params(
      only: T.untyped,
      except: T.untyped,
      queue: T.nilable(T.any(String, Symbol)),
      block: T.nilable(T.proc.void)
    ).returns(TrueClass)
  end
  def assert_no_enqueued_jobs(only: nil, except: nil, queue: nil, &block); end

  # @version >= 8.2.0
  sig do
    type_parameters(:Block)
      .params(
        only: T.untyped,
        except: T.untyped,
        queue: T.nilable(T.any(String, Symbol)),
        block: T.proc.returns(T.type_parameter(:Block))
      ).returns(T.type_parameter(:Block))
  end
  sig { params(only: T.untyped, except: T.untyped, queue: T.nilable(T.any(String, Symbol))).returns(TrueClass) }
  def assert_no_enqueued_jobs(only: nil, except: nil, queue: nil, &block); end

  # @version < 8.2.0
  sig do
    params(
      number: Integer,
      only: T.untyped,
      except: T.untyped,
      queue: T.nilable(T.any(String, Symbol)),
      block: T.nilable(T.proc.void)
    ).returns(TrueClass)
  end
  def assert_performed_jobs(number, only: nil, except: nil, queue: nil, &block); end

  # @version >= 8.2.0
  sig do
    type_parameters(:Block)
      .params(
        number: Integer,
        only: T.untyped,
        except: T.untyped,
        queue: T.nilable(T.any(String, Symbol)),
        block: T.proc.returns(T.type_parameter(:Block))
      ).returns(T.type_parameter(:Block))
  end
  sig { params(number: Integer, only: T.untyped, except: T.untyped, queue: T.nilable(T.any(String, Symbol))).returns(TrueClass) }
  def assert_performed_jobs(number, only: nil, except: nil, queue: nil, &block); end

  # @version < 8.2.0
  sig do
    params(
      only: T.untyped,
      except: T.untyped,
      queue: T.nilable(T.any(String, Symbol)),
      block: T.nilable(T.proc.void)
    ).returns(TrueClass)
  end
  def assert_no_performed_jobs(only: nil, except: nil, queue: nil, &block); end

  # @version >= 8.2.0
  sig do
    type_parameters(:Block)
      .params(
        only: T.untyped,
        except: T.untyped,
        queue: T.nilable(T.any(String, Symbol)),
        block: T.proc.returns(T.type_parameter(:Block))
      ).returns(T.type_parameter(:Block))
  end
  sig { params(only: T.untyped, except: T.untyped, queue: T.nilable(T.any(String, Symbol))).returns(TrueClass) }
  def assert_no_performed_jobs(only: nil, except: nil, queue: nil, &block); end

  sig do
    type_parameters(:Block)
      .params(
        only: T.untyped,
        except: T.untyped,
        queue: T.nilable(T.any(String, Symbol)),
        at: T.untyped,
        block: T.proc.returns(T.type_parameter(:Block))
      ).returns(T.type_parameter(:Block))
  end
  sig { params(only: T.untyped, except: T.untyped, queue: T.nilable(T.any(String, Symbol)), at: T.untyped).returns(Integer) }
  sig do
    type_parameters(:Block)
      .params(only: T.untyped, except: T.untyped, queue: T.nilable(T.any(String, Symbol)), at: T.untyped, block: T.proc.returns(T.type_parameter(:Block)))
      .returns(T.type_parameter(:Block))
  end
  def perform_enqueued_jobs(only: nil, except: nil, queue: nil, at: nil, &block); end
end
