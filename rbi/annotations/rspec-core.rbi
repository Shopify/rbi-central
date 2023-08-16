# typed: true

class RSpec::Core::ExampleGroup
  class << self
    sig { params(args: T.untyped, example_group_block: T.proc.bind(T.untyped).void).void }
    def describe(*args, &example_group_block); end

    sig { params(all_args: T.untyped, block: T.proc.bind(RSpec::Matchers).void).void }
    def it(*all_args, &block); end
  end
end
