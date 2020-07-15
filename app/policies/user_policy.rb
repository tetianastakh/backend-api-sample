class UserPolicy < ApplicationPolicy
  def initialize(user, record = nil, request_params = {})
    @request_params = request_params
    super(user, record)
  end
end
