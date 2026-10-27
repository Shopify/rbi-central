# typed: true

class ActionMailer::Base
  sig do
    params(
      headers: T.untyped,
      block: T.nilable(T.proc.params(arg0: ActionMailer::Collector).void)
    ).returns(Mail::Message)
  end
  def mail(headers = nil, &block); end
end

module ActionMailer::TestHelper
  sig { params(block: T.proc.void).returns(T::Array[Mail::Message]) }
  def capture_emails(&block); end
end
