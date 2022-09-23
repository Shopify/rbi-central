# typed: strong

module Rails
  class << self
    sig { returns(Rails::Application) }
    def application; end

    sig { returns(ActiveSupport::BacktraceCleaner) }
    def backtrace_cleaner; end

    sig { returns(ActiveSupport::Cache::Store) }
    def cache; end

    sig { returns(ActiveSupport::EnvironmentInquirer) }
    def env; end

    sig { returns(ActiveSupport::Logger) }
    def logger; end

    sig { returns(Pathname) }
    def root; end

    sig { returns(String) }
    def version; end
  end
end

class Rails::Application < ::Rails::Engine
  sig { returns(T.untyped) }
  def config; end
end

class Rails::Engine < ::Rails::Railtie
  sig { returns(ActionDispatch::Routing::RouteSet) }
  def routes(&block); end
end

class Rails::Railtie
  sig { params(block: T.proc.bind(Rails::Railtie).void).void }
  def configure(&block); end
end

class Rails::Railtie::Configuration
  sig { params(blk: T.proc.bind(ActiveSupport::Reloader).void).void }
  def to_prepare(&blk); end
end
