# typed: strict

class ActiveRecord::Base
  # @shim: this is included at runtime https://github.com/rails/globalid/blob/v1.0.0/lib/global_id/railtie.rb#L38
  include GlobalID::Identification
end
