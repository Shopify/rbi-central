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
