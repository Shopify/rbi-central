# typed: strict

module PaperTrail::Model::ClassMethods
  sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).void }
  def has_paper_trail(options = {}); end

  sig { returns(T.untyped) }
  def paper_trail; end
end

class ActiveRecord::Base
  extend PaperTrail::Model::ClassMethods
end
