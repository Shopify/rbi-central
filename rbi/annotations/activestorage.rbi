# typed: strict

class ActiveStorage::Attached::One
  # @shim: Methods on Attached::One are delegated to `ActiveStorage::Blob` through `ActiveStorage::Attachment` using `method_missing`
  include ActiveStorage::Blob::Analyzable
  # @shim: Methods on Attached::One are delegated to `ActiveStorage::Blob` through `ActiveStorage::Attachment` using `method_missing`
  include ActiveStorage::Blob::Identifiable
  # @shim: Methods on Attached::One are delegated to `ActiveStorage::Blob` through `ActiveStorage::Attachment` using `method_missing`
  include ActiveStorage::Blob::Representable
end

class ActiveStorage::Attached::Many
  # @shim: Methods on Attached::Many are delegated to `ActiveStorage::Blob` through `ActiveStorage::Attachment` using `method_missing`
  include ActiveStorage::Blob::Analyzable
  # @shim: Methods on Attached::Many are delegated to `ActiveStorage::Blob` through `ActiveStorage::Attachment` using `method_missing`
  include ActiveStorage::Blob::Identifiable
  # @shim: Methods on Attached::Many are delegated to `ActiveStorage::Blob` through `ActiveStorage::Attachment` using `method_missing`
  include ActiveStorage::Blob::Representable
end
