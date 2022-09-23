# typed: strict

module Rails
  class << self
    sig { returns(ActiveSupport::EnvironmentInquirer) }
    def env; end
    
    sig { returns(Application) }
    def application; end
  end
end

class Rails::Application
  class << self
    sig { params(block: T.proc.bind(Rails::Application).void).void }
    def configure(&block); end
  end
  
  sig { params(block: T.proc.bind(Rails::Application).void).void }
  def configure(&block); end
end

class Rails::Engine
  sig { params(block: T.untyped).returns(ActionDispatch::Routing::RouteSet) }
  def routes(&block); end
end
