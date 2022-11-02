# typed: strict

class ActionMailer::Base
  sig { params(headers: T.untyped, block: T.nilable(T.proc.void)).returns(Mail::Message) }
  def mail(headers = nil, &block); end
end
