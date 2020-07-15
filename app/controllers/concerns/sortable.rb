module Sortable
  extend ActiveSupport::Concern

  private

  def sort_params
    opts = params.permit(:field, :direction)
    opts[:field] ||= 'created_at'
    opts[:direction] ||= 'DESC'
    opts.to_h
  end
end
