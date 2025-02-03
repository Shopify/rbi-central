# typed: true

class Minitest::HooksSpec
  sig { params(type: T.nilable(Symbol), block: T.proc.bind(T.attached_class).void).void }
  def self.before(type = nil, &block); end

  sig { params(type: T.nilable(Symbol), block: T.proc.bind(T.attached_class).void).void }
  def self.after(type = nil, &block); end
end
