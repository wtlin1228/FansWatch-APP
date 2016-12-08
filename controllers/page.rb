# frozen_string_literal: true

# FansWatchAPP web application
class FansWatchAPP < Sinatra::Base
  # Home page: show list of all pages
  get '/?' do
    result = GetAllPages.call
    if result.success?
      @data = result.value
    else
      flash[:error] = result.value.message
    end

    slim :page
  end

  # Add a new Facebook page to our systems
  post '/page/?' do
    url_request = UrlRequest.call(params)
    result = CreateNewPage.call(url_request)

    if result.success?
      flash[:notice] = 'Page successfully added'
    else
      flash[:error] = result.value.message
    end

    redirect '/'
  end

  get '/page/:id/?' do
    # TODO: get postings and information from a single page
  end
end
