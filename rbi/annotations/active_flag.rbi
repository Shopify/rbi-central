# typed: true

class ActiveRecord::Base
  # @shim: this is included at runtime https://github.com/kenn/active_flag/blob/master/lib/active_flag/railtie.rb#L6
  extend ActiveFlag::ClassMethods
end
