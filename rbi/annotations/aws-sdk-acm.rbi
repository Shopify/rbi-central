# typed: true

class Aws::ACM::Client
  sig { params(params: T.untyped, options: T.untyped).returns(Aws::ACM::Types::DescribeCertificateResponse) }
  def describe_certificate(params = nil, options = nil); end
end

class Aws::ACM::Types::DescribeCertificateResponse
  Elem = type_member { { fixed: T.untyped } }

  sig { returns(Aws::ACM::Types::CertificateDetail) }
  attr_accessor :certificate
end

class Aws::ACM::Types::CertificateDetail
  Elem = type_member { { fixed: T.untyped } }

  sig { returns(T.nilable(T::Array[Aws::ACM::Types::DomainValidation])) }
  attr_accessor :domain_validation_options
end

class Aws::ACM::Types::DomainValidation
  Elem = type_member { { fixed: T.untyped } }

  sig { returns(Aws::ACM::Types::ResourceRecord) }
  attr_accessor :resource_record
end

class Aws::ACM::Types::ResourceRecord
  Elem = type_member { { fixed: T.untyped } }

  sig { returns(String) }
  attr_accessor :name

  sig { returns(String) }
  attr_accessor :type

  sig { returns(String) }
  attr_accessor :value
end
