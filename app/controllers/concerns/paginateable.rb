module Paginateable
  extend ActiveSupport::Concern

  private

  def pagination_params
    opts = params.permit(:page, :per_page)
    opts[:page] ||= 1
    opts[:per_page] ||= 10
    # FIXME: There is a bug with ActionController::Parameters that does not
    # inherit the hash class properly so will_paginate fails. Temp fix to convert
    # it to a hash before returning.
    opts.to_h
  end
end
