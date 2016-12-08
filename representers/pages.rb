# frozen_string_literal: true
require_relative 'page'

# Represents overall page information for JSON API output
class GroupsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :pages, extend: PageRepresenter, class: Page
end
