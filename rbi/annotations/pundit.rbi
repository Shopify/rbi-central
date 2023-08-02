# typed: true

module Pundit::Authorization
  sig { void }
  def skip_authorization; end

  sig { void }
  def skip_policy_scope; end
end
