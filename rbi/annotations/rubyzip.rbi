# typed: true

class Zip::File
  # @version >= 2.4.0, < 3.0.0
  sig do
    type_parameters(:R)
      .params(
        file_name: T.any(String, Pathname),
        dep_create: T::Boolean,
        create: T::Boolean,
        options: T.untyped,
        block: T.proc.params(zip_file: Zip::File).returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  sig do
    params(
      file_name: T.any(String, Pathname),
      dep_create: T::Boolean,
      create: T::Boolean,
      options: T.untyped,
    ).returns(Zip::File)
  end
  def self.open(file_name, dep_create = T.unsafe(nil), create: T.unsafe(nil), **options, &block); end

  # @version >= 3.0.0, < 3.2.0
  sig do
    type_parameters(:R)
      .params(
        file_name: T.any(String, Pathname),
        create: T::Boolean,
        restore_ownership: T::Boolean,
        restore_permissions: T::Boolean,
        restore_times: T::Boolean,
        compression_level: Integer,
        block: T.proc.params(zip_file: Zip::File).returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  sig do
    params(
      file_name: T.any(String, Pathname),
      create: T::Boolean,
      restore_ownership: T::Boolean,
      restore_permissions: T::Boolean,
      restore_times: T::Boolean,
      compression_level: Integer,
    ).returns(Zip::File)
  end
  def self.open(
    file_name,
    create: T.unsafe(nil),
    restore_ownership: T.unsafe(nil),
    restore_permissions: T.unsafe(nil),
    restore_times: T.unsafe(nil),
    compression_level: T.unsafe(nil),
    &block
  ); end

  # @version >= 3.2.0
  sig do
    type_parameters(:R)
      .params(
        file_name: T.any(String, Pathname),
        create: T::Boolean,
        restore_ownership: T::Boolean,
        restore_permissions: T::Boolean,
        restore_times: T::Boolean,
        compression_level: Integer,
        suppress_extra_fields: T.any(T::Boolean, Symbol, T::Array[Symbol]),
        block: T.proc.params(zip_file: Zip::File).returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  sig do
    params(
      file_name: T.any(String, Pathname),
      create: T::Boolean,
      restore_ownership: T::Boolean,
      restore_permissions: T::Boolean,
      restore_times: T::Boolean,
      compression_level: Integer,
      suppress_extra_fields: T.any(T::Boolean, Symbol, T::Array[Symbol]),
    ).returns(Zip::File)
  end
  def self.open(
    file_name,
    create: T.unsafe(nil),
    restore_ownership: T.unsafe(nil),
    restore_permissions: T.unsafe(nil),
    restore_times: T.unsafe(nil),
    compression_level: T.unsafe(nil),
    suppress_extra_fields: T.unsafe(nil),
    &block
  ); end
end
