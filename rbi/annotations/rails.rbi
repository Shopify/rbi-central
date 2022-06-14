# typed: strict

module Rails
  class << self
    sig { returns(ActiveSupport::EnvironmentInquirer) }
    def env; end
  end

  sig { returns(Application) }
  def self.application; end
end

class Rails::Application
  sig { params(block: T.proc.bind(Rails::Application).void).void }
  def configure(&block); end
end

class Rails::Engine
  sig { params(block: T.untyped).returns(ActionDispatch::Routing::RouteSet) }
  def routes(&block); end

  class << self
    sig { params(block: T.untyped).returns(ActionDispatch::Routing::RouteSet) }
    def routes(&block); end

    sig { returns(Rails::Paths::Root) }
    def paths; end

    sig { returns(Module) }
    def helpers; end
  end
end
