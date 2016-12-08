# frozen_string_literal: true

# Gets list of all pages from API
class GetAllPages
  extend Dry::Monads::Either::Mixin

  def self.call
    results = HTTP.get("#{FansWatchAPP.config.FANSWATCH_API}/allpage")
    Right(PagesRepresenter.new(Pages.new)
                           .from_json(results.body))
  rescue
    Left(Error.new('Our servers failed - we are investigating!'))
  end
end
