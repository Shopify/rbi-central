# typed: true

# `Pagy::Method` is included in the app controller/view to provide the `#pagy` method.
module Pagy::Method
  protected

  # `paginator` selects the paginator module, and the return value depends on it:
  # most paginators return a `[Pagy, records]` pair, `:calendar` returns a
  # `[Pagy::Calendar, Pagy, records]` triplet, and the search paginators return a bare
  # `Pagy` object in passive mode. Hence the untyped return.
  sig { params(paginator: Symbol, collection: T.untyped, options: T.untyped).returns(T.untyped) }
  def pagy(paginator = :offset, collection, **options); end
end
