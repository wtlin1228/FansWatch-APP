# frozen_string_literal: true

# Gets list of all groups from API
class CreateNewPage
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(url_request)
    Dry.Transaction(container: self) do
      step :validate_url_request
      step :call_api_to_load_page
      step :return_api_result
    end.call(url_request)
  end

  register :validate_url_request, lambda { |url_request|
    if url_request.success?
      Right(url_request[:page_url])
    else
      message = ErrorFlattener.new(
        ValidationError.new(url_request)
      ).to_s
      Left(Error.new(message))
    end
  }

  register :call_api_to_load_page, lambda { |url|
    begin
      Right(HTTP.post("#{FansWatchAPP.config.FANSWATCH_API}/db_page/json",
                      json: { url: url }))
    rescue
      Left(Error.new('Our servers failed - we are investigating!'))
    end
  }

  register :return_api_result, lambda { |http_result|
    data = http_result.body.to_s
    if http_result.status == 200
      Right(PageRepresenter.new(Page.new).from_json(data))
    else
      message = ErrorFlattener.new(
        ApiErrorRepresenter.new(ApiError.new).from_json(data)
      ).to_s
      Left(Error.new(message))
    end
  }
end