# typed: true

module Delayed::MessageSending
  sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).returns(T.self_type) }
  def delay(options = nil); end
end

class Object
  include Delayed::MessageSending
end

class Module
  include Delayed::MessageSendingClassMethods
end
