class HealthcheckController < ActionController::API
  def status
    head :ok
  end
end
