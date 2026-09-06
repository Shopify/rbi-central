# typed: true

module I18n::Base
  sig { returns(T::Array[Symbol]) }
  def available_locales; end

  sig do
    params(value: T.nilable(T.any(String, Symbol, T::Array[T.any(String, Symbol)])))
      .returns(T.nilable(T.any(String, Symbol, T::Array[T.any(String, Symbol)])))
  end
  def available_locales=(value); end

  sig { returns(I18n::Config) }
  def config; end

  sig { returns(Symbol) }
  def default_locale; end

  sig { params(value: T.nilable(T.any(String, Symbol))).returns(T.nilable(T.any(String, Symbol))) }
  def default_locale=(value); end

  sig { returns(String) }
  def default_separator; end

  sig { params(value: String).returns(String) }
  def default_separator=(value); end

  sig { returns(T::Boolean) }
  def enforce_available_locales; end

  sig { params(value: T::Boolean).returns(T::Boolean) }
  def enforce_available_locales=(value); end

  sig { returns(Symbol) }
  def locale; end

  sig { params(value: T.nilable(T.any(String, Symbol))).returns(T.nilable(T.any(String, Symbol))) }
  def locale=(value); end

  sig { returns(I18n::Config) }
  def writable_config; end
end
