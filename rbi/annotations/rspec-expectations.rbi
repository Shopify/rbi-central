# typed: true

module RSpec
  class << self
    sig { params(args: T.untyped, example_group_block: T.proc.bind(T.class_of(RSpec::Core::ExampleGroup)).void).void }
    def describe(*args, &example_group_block); end
  end
end
